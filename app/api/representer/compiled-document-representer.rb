require 'roar/representer/json'
require 'roar/representer/feature/hypermedia'
require 'api/url-helpers'

module CompiledDocumentRepresenter
  include Roar::Representer::JSON
  include Roar::Representer::Feature::Hypermedia
  include Cocowrite::API::UrlHelpers

  link :self do
    compiled_document_url(self)
  end

end
