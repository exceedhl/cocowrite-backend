require File.dirname(__FILE__) + '/../spec_helper'
require "api/projects"
require "model/project"

describe "Projects api" do
  include Rack::Test::Methods
  include Cocowrite::API::UrlHelpers

  def app
    Cocowrite::API::Projects
  end
  
  before(:each) do
    Project.delete_all
  end
  
  around(:each) do |example|
    EM.synchrony do
      example.run
      EM.stop
    end
  end

  context 'when POST /projects' do
    
    it 'should create a new project from a github repo' do
      repo_fullname = "exceedhl/clabric"
      name = "clabric"
      description = "fabric like tool for clojure"
      url = "https://github.com/exceedhl/clabric"
      response = <<-END
      {
        "name": "clabric",
        "full_name": "exceedhl/clabric",
        "html_url": "https://github.com/exceedhl/clabric",
        "description": "fabric like tool for clojure"
      }
      END
      stub_request(:get, "https://api.github.com/repos/#{repo_fullname}")
        .to_return(:body => response, :status => 200)
      
      post "/projects", {:repo => "https://github.com/#{repo_fullname}"}
      expect(last_response.status).to be(201)
      body = JSON.parse(last_response.body)
      expect(body['name']).to eq(name)
      expect(body['full_name']).to eq(repo_fullname)
      expect(body['description']).to eq(description)
      expect(body['url']).to eq(url)
      expect(body['uuid']).to_not be_nil
      
      p = Project.where(name: name).first
      expect(p.description).to eq(description)
      expect(p.url).to eq(url)
    end
    
    it 'should return error if github repo url is invalid' do
      repo_fullname = "someone/invalidrepo"
      response = <<-END
      {
        "message": "Some error from github",
        "documentation_url": "http://developer.github.com/v3"
      }
      END
      stub_request(:get, "https://api.github.com/repos/#{repo_fullname}")
        .to_return(:body => response, :status => 404)

      post "/projects", {:repo => "https://github.com/#{repo_fullname}"}
      expect(last_response.status).to be(403)
      body = JSON.parse(last_response.body)
      expect(body['error']).to eq("Some error from github")
      expect(Project.all.size).to be(0)
    end
    
    it 'should return error if param is incorrect' do
      post "/projects", {:repo => "incorrect param"}
      expect(last_response.status).to be(403)
      body = JSON.parse(last_response.body)
      expect(body['error']).to eq("You must provide a valid github repo url")
    end

  end
  
  context "when GET /projects/:uuid" do
  
    it 'should return project by uuid' do
      project = Project.make!
      get "/projects/#{project.uuid}"
      body = JSON.parse(last_response.body)
      expect(last_response.status).to be(200)
      expect(body['name']).to eq(project.name)
      expect(body['description']).to eq(project.description)
      expect(body['url']).to eq(project.url)
      expect(body['uuid']).to eq(project.uuid)
      expect(body['links'][0]['href']).to eq(projects_url(body['uuid']))
    end
    
    it 'should return 404 if no project is found' do
      get "/projects/no-such-a-project"
      expect(last_response.status).to be(404)      
    end
    
    it 'should return 405 if no uuid id provided' do
      get "/projects"
      expect(last_response.status).to be(405)      
    end
    
  end
  
end
