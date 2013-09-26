$:.unshift(File.dirname(__FILE__) + '/')

require 'initialization'
require 'goliath'
require 'api/projects'

class Application < Goliath::API

  def response(env)
    Cocowrite::API::Projects.call(env)
  end

end
