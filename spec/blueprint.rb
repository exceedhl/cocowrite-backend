require 'machinist/active_record'
require 'model/project'
require 'model/session'
require 'model/compiled-document'

Project.blueprint do
  name { "clabric" }  
  github_username { "exceedhl" }  
  full_name {"exceedhl/clabric"}
  description { "fabric in closure" }
  url { "http://github.com/exceedhl/clabric" }
  created_at { Time.now }
end

Session.blueprint do
  uuid { "test-session-id" }
  github_username { "exceedhl" }
  github_token { "test-token" }
  created_at { Time.now }
end

CompiledDocument.blueprint do
  project_id { 1 }
  sha { "fefa1e283874e4a87d88a99b39402d3797d966db" }
end
