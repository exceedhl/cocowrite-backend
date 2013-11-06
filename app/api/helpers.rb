require 'api/github-client'

module Cocowrite
  module API
    
    module Helpers
      
      def githubClient
        env["githubClient"] || GithubClient.new 
      end
      
      def logger
        Grape::API.logger
      end
      
    end
  end
end
