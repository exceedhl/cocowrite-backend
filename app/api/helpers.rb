require 'api/github-client'

module Cocowrite
  module API
    
    module Helpers
      
      def githubClient
        env["githubClient"] || GithubClient.new 
      end
      
    end
  end
end
