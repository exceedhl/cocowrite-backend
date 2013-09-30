$:.unshift(File.dirname(__FILE__) + '/')

require 'initialization'
require 'goliath'
require 'api/projects'
require 'middleware/cors'

class Application < Goliath::API
  
  use Goliath::Contrib::Rack::CorsAccessControl

  def response(env)
    Cocowrite::API::Projects.call(env)
  end

end
