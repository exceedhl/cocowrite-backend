require 'machinist/active_record'
require 'model/project'

Project.blueprint do
  name { "clabric" }  
  full_name {"exceedhl/clabric"}
  description { "fabric in closure" }
  url { "http://github.com/exceedhl/clabric" }
  created_at { Time.now }
end

