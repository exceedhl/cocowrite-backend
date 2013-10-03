require 'model/project'
require 'api/representer/project_representer'
require 'em-synchrony/em-http'

module Cocowrite
  module API
    
    GITHUB_URL_PATTERN = /^\S+\/(?<repo_fullname>\S+\/\S+)$/
    
    class GitHubRepoURL < Grape::Validations::Validator
      def validate_param!(attr_name, params)
        unless params[attr_name] =~ GITHUB_URL_PATTERN
          throw :error, status: 403, message: "You must provide a valid github repo url"
        end
      end
    end
    
    class Projects < Grape::API
      
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
                :full_name => res["full_name"],
                :description => res["description"], 
                :url => res["html_url"], 
                :created_at => Time.now})
              .extend(ProjectRepresenter)
              .to_json
          else
            error!(JSON.parse(req.response)["message"], 403)
          end
        end
        
        route_param :uuid do
          get do
            project = Project.where(:uuid => params[:uuid]).first
            error!("Project #{params[:uuid]} does not exist", 404) if project.nil?
            project.extend(ProjectRepresenter).to_json
          end
        end
        
      end      
    end
  end
end
