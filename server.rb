$:.unshift(File.dirname(__FILE__) + '/')

require 'initialization'
require 'api/application'
require 'middleware/cors'
require 'middleware/github-authenticator'

class DevGithubAuthenticator
  include Goliath::Rack::AsyncMiddleware
  
  def call(env)
    env["githubClient"] = Cocowrite::API::GithubClient.new(
      {"client_id" => CONFIG["github"]["client_id"], 
        "client_secret" => CONFIG["github"]["client_secret"]})
    super(env)
  end
end

class Server < Application
  use Goliath::Contrib::Rack::CorsAccessControl
  use GithubAuthenticator unless Goliath.env?('development')
  use DevGithubAuthenticator if Goliath.env?('development')
end
