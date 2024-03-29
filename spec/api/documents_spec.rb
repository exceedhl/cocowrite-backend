require File.dirname(__FILE__) + '/../spec_helper'
require 'api/documents'
require 'model/project'
require 'model/compiled-document'

describe "Documents api" do

  def app
    Cocowrite::API::Documents
  end
  
  around(:each) do |example|
    EM.synchrony do
      example.run
      EM.stop
    end
  end

  before(:each) do
    Project.delete_all
    CompiledDocument.delete_all
  end

  context 'when GET /projects/:uuid/documents/:sha/pdf' do
    
    it 'should return a url of generated pdf file' do
      docsha = "fefa1e283874e4a87d88a99b39402d3797d966db"
      project = Project.make!
      response = "some doc contnet"
      stub_request(:get, "https://api.github.com/repos/#{project.full_name}/git/blobs/#{docsha}").with(:headers => {"Accept" => "application/vnd.github.VERSION.raw"})
        .to_return(:body => response, :status => 200)
      
      get "/projects/#{project.uuid}/documents/#{docsha}/pdf"
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)['links'][0]['href']).to eq("http://www.local.xxx:8888/#{docsha}.pdf")
      cd = CompiledDocument.where({:project_id => project, :sha => docsha, :format => 'pdf'}).first
      expect(cd.status).to eq(:compilation_succeed)
    end
    
    it 'should not generate pdf twice for same file' do
      docsha = "fefa1e283874e4a87d88a99b39402d3797d966db"
      project = Project.make!
      response = "some doc contnet"
      stub_request(:get, "https://api.github.com/repos/#{project.full_name}/git/blobs/#{docsha}").with(:headers => {"Accept" => "application/vnd.github.VERSION.raw"})
        .to_return(:body => response, :status => 200)
      
      get "/projects/#{project.uuid}/documents/#{docsha}/pdf"
      get "/projects/#{project.uuid}/documents/#{docsha}/pdf"
      cd = CompiledDocument.where({:project_id => project, :sha => docsha, :format => 'pdf', :status => CompiledDocument.statuses(:compilation_succeed)})
      expect(cd.size).to eq(1)
    end
    
    it 'should genereate pdf if there are no successful generated document' do
      project = Project.make!
      cd = CompiledDocument.make!(:project_id => project.id, :status => :compilation_fail, :format => 'pdf')
      response = "some doc contnet"
      stub_request(:get, "https://api.github.com/repos/#{project.full_name}/git/blobs/#{cd.sha}").with(:headers => {"Accept" => "application/vnd.github.VERSION.raw"})
        .to_return(:body => response, :status => 200)
      
      get "/projects/#{project.uuid}/documents/#{cd.sha}/pdf"
      cd = CompiledDocument.where({:project_id => project, :sha => cd.sha, :format => 'pdf'})
      expect(cd.size).to eq(2)
    end
  
    it 'should return 404 if project not found' do
      project_uuid = "invalid-uuid"
      get "/projects/#{project_uuid}/documents/whatever/pdf"

      expect(last_response.status).to eq(404)
      expect(JSON.parse(last_response.body)['error']).to eq("Project with uuid #{project_uuid} is not found")
      expect(CompiledDocument.all.size).to eq(0)
    end

    it 'should return 404 if document not found' do
      docsha = "somesha"
      project = Project.make!
      response = <<-END
      {
        "message": "Not Found",
        "documentation_url": "http://developer.github.com/v3"
      }
      END
      stub_request(:get, "https://api.github.com/repos/#{project.full_name}/git/blobs/#{docsha}")
        .to_return(:body => response, :status => 404)
      
      get "/projects/#{project.uuid}/documents/#{docsha}/pdf"
      
      expect(last_response.status).to eq(404)
      expect(JSON.parse(last_response.body)['error']).to eq("Not Found")
      expect(CompiledDocument.all.size).to eq(0)
    end
    
    it 'should return 500 if pdf can not be generated' do
      docsha = "fefa1e283874e4a87d88a99b39402d3797d966db"
      project = Project.make!
      response = "some doc contnet"
      stub_request(:get, "https://api.github.com/repos/#{project.full_name}/git/blobs/#{docsha}").with(:headers => {"Accept" => "application/vnd.github.VERSION.raw"})
        .to_return(:body => response, :status => 200)
      Cocowrite::DocumentConverter::LATEX_TEMPLATE = "non/existent/template"
      
      get "/projects/#{project.uuid}/documents/#{docsha}/pdf"
      expect(last_response.status).to eq(500)
      expect(JSON.parse(last_response.body)['error']).to eq("Document conversion failed.")
      cd = CompiledDocument.where({:project_id => project, :sha => docsha, :format => 'pdf'}).first
      expect(cd.status).to eq(:compilation_fail)
      
    end
    
  end
  
end
