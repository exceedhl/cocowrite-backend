require File.dirname(__FILE__) + '/../spec_helper'
require 'api/authenticate'
require 'model/session'

describe "Authenticate api" do

  def app
    Cocowrite::API::Authenticate
  end
  
  around(:each) do |example|
    EM.synchrony do
      example.run
      EM.stop
    end
  end
  
  before(:each) do
    Session.delete_all
  end
  
  context 'when GET /authenticated' do
    
    it 'should redirect to front page after getting github access code and set auth cookie' do
      access_token = "e72e16c7e42f292c6912e7710c838347ae178b4a"
      stub_request(:post, "https://github.com/login/oauth/access_token")
        .with(:body => "client_id=client%20id&client_secret=client%20secret&code=somecode", 
        :headers => {"Accept" => "application/json"})
        .to_return(:body => '{"access_token":"' + access_token + '", "scope":"repo,user", "token_type":"bearer"}', :status => 200)
      userinfo = <<-END
{
  "login": "octocat",
  "url": "https://api.github.com/users/octocat",
  "name": "someone"
}
END
      stub_request(:get, "https://api.github.com/user")
        .with(:query => {"access_token" => access_token})
        .to_return(:body => userinfo, :status => 200)
      
      get "/authenticated", {:code => "somecode"}
      expect(last_response).to be_redirect
      expect(last_response.location).to eq("http://www.cocowrite.com")
      session = Session.where(:github_token => access_token).first
      expect(session.github_username).to eq("someone")
      expect(last_response.header["Set-Cookie"]).to match(/session_id=#{session.uuid}; domain=\.cocowrite\.com; path=\//)
    end

    it 'should return 403 if github userinfo can not be fetched' do
      access_token = "e72e16c7e42f292c6912e7710c838347ae178b4a"
      stub_request(:post, "https://github.com/login/oauth/access_token")
        .with(:body => "client_id=client%20id&client_secret=client%20secret&code=somecode", 
        :headers => {"Accept" => "application/json"})
        .to_return(:body => '{"access_token":"' + access_token + '", "scope":"repo,user", "token_type":"bearer"}', :status => 200)
      stub_request(:get, "https://api.github.com/user")
        .with(:query => {"access_token" => access_token})
        .to_return(:status => 400)
      
      get "/authenticated", {:code => "somecode"}
      expect(last_response.status).to be(403)
      expect(JSON.parse(last_response.body)["error"]).to eq("can not fetch user info")
    end
    
    it 'should return 401 if can not get github access code' do
      stub_request(:post, "https://github.com/login/oauth/access_token")
        .with(:body => "client_id=client%20id&client_secret=client%20secret&code=somecode", 
        :headers => {"Accept" => "application/json"})
        .to_return(:body => '{"error":"Not Found"}', :status => 404)
      
      get "/authenticated", {:code => "somecode"}
      expect(last_response.status).to be(401)
    end
    
    it 'should return 405 if code param is not provided' do
      get "/authenticated"
      expect(last_response.status).to be(403)
    end
    
  end
 
end
