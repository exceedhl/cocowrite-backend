require 'model/session'
require 'api/github-client'

module Cocowrite
  module API
    
    ACCESS_TOKEN_URL = "https://github.com/login/oauth/access_token"
    
    class Authenticate < Grape::API
      
      format :json
      
      rescue_from :all
      
      params do
        requires :code, type: String, desc: "Github temp code."
      end
      get "/authenticated" do 
        client = GithubClient.new
        res = client.post(ACCESS_TOKEN_URL, {:client_id => CONFIG["github"]["client_id"], :client_secret => CONFIG["github"]["client_secret"], :code => params[:code]}, {"Accept" => "application/json"})
        error! "can not get access token", 401 unless res.ok?
        userinfo = client.get "/user", {}, {"access_token" => res.data["access_token"]}
        error! "can not fetch user info", 403 unless userinfo.ok?
        session = Session.create({:github_token => res.data["access_token"], :github_username => userinfo.data["name"]})
        cookies[:session_id] = {
          :value => session.uuid,
          :domain => ".#{CONFIG['root_domain']}",
          :path => "/"
        }
        redirect CONFIG["front_root_url"]
      end
    end
  end
end
