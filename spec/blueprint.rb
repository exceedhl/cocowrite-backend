require 'machinist/active_record'
require 'model/project'

Project.blueprint do
  name { "exceedhl/clabric" }  
  description { "fabric in closure" }
  url { "http://github.com/exceedhl/clabric" }
  created_at { Time.now }
end

