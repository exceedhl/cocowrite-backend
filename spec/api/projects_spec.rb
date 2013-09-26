require File.dirname(__FILE__) + '/../spec_helper'
require "api/projects"
require "model/project"

describe "Projects api" do
  include Rack::Test::Methods

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
      response = <<-END
      {
        "name": "clabric",
        "html_url": "https://github.com/exceedhl/clabric",
        "description": "fabric like tool for clojure"
      }
      END
      stub_request(:get, "https://api.github.com/repos/#{repo_fullname}")
        .to_return(:body => response, :status => 200)
      
      post "/projects", {:repo => "https://github.com/#{repo_fullname}"}
      expect(last_response.status).to be(201)
      
      p = Project.where(name: "clabric").first
      expect(p.description).to eq("fabric like tool for clojure")
      expect(p.url).to eq("https://github.com/exceedhl/clabric")
    end
    
    it 'should return error if github repo url is invalid' do
      repo_fullname = "someone/invalidrepo"
      response = <<-END
      {
        "message": "Not Found",
        "documentation_url": "http://developer.github.com/v3"
      }
      END
      stub_request(:get, "https://api.github.com/repos/#{repo_fullname}")
        .to_return(:body => response, :status => 404)

      post "/projects", {:repo => "https://github.com/#{repo_fullname}"}
      expect(last_response.status).to be(403)
      expect(error_message(last_response)).to eq("invalid github repo")
      expect(Project.all.size).to be(0)
    end
    
    it 'should return error if param is incorrect' do
      post "/projects", {:repo => "incorrect param"}
      expect(last_response.status).to be(403)
      expect(error_message(last_response)).to eq("must provide valid github repo url")
    end

  end

  def error_message(response) 
    JSON.parse(last_response.body)["error"]
  end
  
end
