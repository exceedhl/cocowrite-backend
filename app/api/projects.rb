require 'model/project'
require 'api/representer/project-representer'
require 'api/helpers'

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
      
      helpers Helpers
      
      format :json
      
      rescue_from :all
      
      resources :users do
        route_param :github_username do
          resources :projects do
            
            params do
              requires :repo, git_hub_repo_url: true
            end
            post do
              repo_fullname = GITHUB_URL_PATTERN.match(params[:repo])[:repo_fullname]
              res = githubClient.get "/repos/#{repo_fullname}"
              if (res.ok?) 
                data = res.data
                Project.create({
                    :name => data["name"],
                    :github_username => params[:github_username],
                    :full_name => data["full_name"],
                    :description => data["description"], 
                    :url => data["html_url"]})
                  .extend(ProjectRepresenter)
              else
                error!(res.data["message"], 403)
              end
            end
            
            route_param :uuid do
              get do
                project = Project.where(:uuid => params[:uuid]).first
                error!("Project #{params[:uuid]} does not exist", 404) if project.nil?
                project.extend(ProjectRepresenter)
              end
            end

            get do
              projects = Project.where(github_username: params[:github_username])
              projects.each do |p|
                p.extend(ProjectRepresenter)
              end
              projects
            end
            
          end
        end
      end
    end
  end
end
