require 'roar/representer/json'
require 'roar/representer/feature/hypermedia'

module ProjectRepresenter
  include Roar::Representer::JSON
  include Roar::Representer::Feature::Hypermedia
  include Cocowrite::API::UrlHelpers

  property :name
  property :description
  property :url
  property :uuid
  
  link :self do
    projects_url(uuid)
  end

end
