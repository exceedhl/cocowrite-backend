require 'roar/representer/json'
require 'roar/representer/feature/hypermedia'
require 'api/url-helpers'

module ProjectRepresenter
  include Roar::Representer::JSON
  include Roar::Representer::Feature::Hypermedia
  include Cocowrite::API::UrlHelpers

  property :name
  property :github_username
  property :full_name
  property :description
  property :url
  property :uuid
  
  link :self do
    projects_url(uuid)
  end

end
