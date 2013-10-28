require 'api/projects'
require 'api/documents'
require 'api/authenticate'

class Cocowrite::API::All < Grape::API
  mount Cocowrite::API::Projects
  mount Cocowrite::API::Documents
  mount Cocowrite::API::Authenticate
end
