require 'model/project'
require 'em-synchrony'
require 'em-synchrony/em-http'

module Cocowrite
  module API
    
    GITHUB_URL_PATTERN = /^\S+\/(?<repo_fullname>\S+\/\S+)$/
    
    module JSONHelpers
      def error_message(error) 
        "{\"error\": \"#{error}\"}"
      end
    end

    class GitHubRepoURL < Grape::Validations::Validator
      include Cocowrite::API::JSONHelpers
      
      def validate_param!(attr_name, params)
        unless params[attr_name] =~ GITHUB_URL_PATTERN
          throw :error, status: 403, message: error_message("must provide valid github repo url")
        end
      end
    end
    
    class Projects < Grape::API
      
      helpers JSONHelpers
      
      rescue_from :all
      
      resources :projects do 

        params do
          requires :repo, git_hub_repo_url: true
        end
        post do
          repo_fullname = GITHUB_URL_PATTERN.match(params[:repo])[:repo_fullname]
          req = EM::HttpRequest.new("https://api.github.com/repos/#{repo_fullname}").get
          if (req.response_header.status == 200) 
            res = JSON.parse(req.response)
            Project.create({
                :name => res["name"], 
                :description => res["description"], 
                :url => res["html_url"], 
                :created_at => Time.now})
          else
            error!(error_message("invalid github repo"), 403)
          end
        end
        
      end      
    end
  end
end
