require File.dirname(__FILE__) + '/../spec_helper'
require 'middleware/github-authenticator'
require 'model/session'
require 'goliath/test_helper'

class StubApi < Goliath::API
  use GithubAuthenticator

  def response(env)
    if /^\/(authenticated)/.match(env['REQUEST_PATH'])
      [200, {}, "authenticated"]
    else
      client = env['githubClient']
      client.get "/user"
      client.post "/user", {}
      [200, {}, env['session'].github_username]
    end
  end
end

describe "GithubAuthenticator" do
  
  include Goliath::TestHelper

  before(:each) do
    WebMock.disable_net_connect!(:allow_localhost => true)
    Session.delete_all
  end
  
  it 'should not check session for /authenticated' do
    with_api(StubApi) do |api|
      get_request({:path => "/authenticated"}) do |req|
        expect(req.response_header.status).to be(200)
        expect(req.response).to eq("authenticated")
      end
    end
  end
  
  it 'should fetch access_token if session is valid' do
    stub_request(:get, "https://api.github.com/user?access_token=test-token").
      to_return(:status => 200, :body => "", :headers => {})
    stub_request(:post, "https://api.github.com/user").
      with(:body => "access_token=test-token").
      to_return(:status => 200, :body => "", :headers => {})

    Session.make!
    with_api(StubApi) do |api|
      get_request({:path => "/", 
          :head => {"Cookie" => 'session_id=test-session-id; $Path="/"'}}) do |req|
        expect(req.response_header.status).to be(200)
        expect(req.response).to eq("exceedhl")
      end
    end
  end
  
  it 'should return 401 if cookie missing' do
    with_api(StubApi) do |api|
      get_request(:path => "/") do |req|
        expect(req.response_header.status).to be(401)
        expect(JSON.parse(req.response)['error']).to eq("no session found")
      end
    end
  end
  
  it 'should return 401 if session is invalid' do
    with_api(StubApi) do |api|
      get_request(:path => "/", 
        :head => {"Cookie" => 'session_id=invalid-session-id; $Path="/"'}) do |req|
        expect(req.response_header.status).to be(401)
        expect(JSON.parse(req.response)['error']).to eq("session invalid")
      end
    end
  end
  
end
