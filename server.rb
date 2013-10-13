$:.unshift(File.dirname(__FILE__) + '/')

require 'initialization'
require 'goliath'
require 'api/all'
require 'middleware/cors'

class Application < Goliath::API
  
  use Goliath::Contrib::Rack::CorsAccessControl

  def response(env)
    Cocowrite::API::All.call(env)
  end

end
