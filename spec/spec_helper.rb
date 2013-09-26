$:.unshift(File.dirname(__FILE__) + '/../')

require 'initialization'

require 'rack/test'
require 'webmock/rspec'

module JSONTestHelpers
  
  def error_message(response) 
    JSON.parse(last_response.body)["error"]
  end

end

RSpec.configure do |c|
  c.include JSONTestHelpers
end
