require 'em-synchrony/em-http'

module Cocowrite
  module API

    class GitHubClient
      
      ROOT_URL = "https://api.github.com"
      
      def get(resource, headers = {})
        req = EM::HttpRequest.new("#{ROOT_URL}#{resource}").get :head => headers
        RestResponse.new req.response_header, req.response
      end
      
    end

    class RestResponse
      
      attr_reader :header, :body
      
      def initialize(header, body)
        @header = header
        @body = body
      end
      
      def ok?
        @header.status == 200
      end
      
      def data
        JSON.parse(@body)
      end
    end
    
  end
end
