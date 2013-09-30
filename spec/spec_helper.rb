$:.unshift(File.dirname(__FILE__) + '/../')

require 'initialization'

require 'rack/test'
require 'webmock/rspec'

module JSONTestHelpers
  
end

RSpec.configure do |c|

  c.include JSONTestHelpers
  
end

require 'blueprint'
