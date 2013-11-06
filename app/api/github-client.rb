require 'em-synchrony/em-http'

module Cocowrite
  module API

    class GithubClient
      
      ROOT_URL = "https://api.github.com"
      
      def initialize(options = {})
        @options = options
        @logger = Grape::API.logger
      end
      
      def get(resource, headers = {}, query = {})
        url = getUrl(resource)
        @logger.debug "Get github resource: #{url}"
        req = EM::HttpRequest.new(url).get :head => headers, :query => @options.merge(query)
        RestResponse.new req.response_header, req.response
      end
      
      def post(resource, body, headers = {}) 
        url = getUrl(resource)
        @logger.debug "Post github resource: #{url}"
        req = EM::HttpRequest.new(url).post :body => @options.merge(body), :head => headers
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
