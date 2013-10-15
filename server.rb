$:.unshift(File.dirname(__FILE__) + '/')

require 'initialization'
require 'goliath'
require 'api/all'
require 'middleware/cors'
require 'api/github-client'

class Application < Goliath::API
  
  use Goliath::Contrib::Rack::CorsAccessControl
  
  def response(env)
    m = /^\/github(.*)/.match(env['REQUEST_PATH'])
    if m
      headers = { "Accept" => env["HTTP_ACCEPT"] }
      client = Cocowrite::API::GitHubClient.new
      response = client.get m[1], headers
      [response.status, response.header, response.body]
    else
      Cocowrite::API::All.call(env)
    end
  end

end
