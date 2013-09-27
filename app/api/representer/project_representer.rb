require 'roar/representer/json'


module ProjectRepresenter
  include Roar::Representer::JSON

  property :name
  property :description
  property :url
  property :uuid

end
