require 'em-synchrony/em-http'

module Cocowrite
  module API

    class GitHubClient
      
      ROOT_URL = "https://api.github.com"
      
      def get(resource, headers = {}, query = {})
        req = EM::HttpRequest.new(getUrl(resource)).get :head => headers, :query => query
        RestResponse.new req.response_header, req.response
      end
      
      def post(resource, body, headers = {}) 
        req = EM::HttpRequest.new(getUrl(resource)).post :body => body, :head => headers
        RestResponse.new req.response_header, req.response
      end
      
      private
      def getUrl(resource) 
        if resource =~ /^(http|https):\/\//
          resource
        else
          "#{ROOT_URL}#{resource}"
        end
      end
    end

    class RestResponse
      
      attr_reader :header, :body
      
      def initialize(header, body)
        @header = header
        @body = body
      end
      
      def status
        @header.status
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
