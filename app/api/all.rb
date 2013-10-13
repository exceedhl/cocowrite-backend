require 'api/projects'
require 'api/documents'

class Cocowrite::API::All < Grape::API
  mount Cocowrite::API::Projects
  mount Cocowrite::API::Documents
end
