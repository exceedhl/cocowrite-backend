$:.unshift(File.dirname(__FILE__) + '/../')

require 'initialization'

require 'rack/test'
require 'webmock/rspec'
require 'api/url-helpers'

module JSONTestHelpers
  
end

RSpec.configure do |c|

  c.include JSONTestHelpers
  c.include Rack::Test::Methods
  c.include Cocowrite::API::UrlHelpers
  
end

require 'blueprint'
