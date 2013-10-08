require 'model/project'
require 'model/compiled-document'
require 'api/representer/compiled-document-representer'
require 'util/document-converter'
require 'api/github-client'

module Cocowrite
  module API
    
    class Documents < Grape::API
      
      format :json
      
      rescue_from :all
      
      resources :projects do 
        
        params do
          requires :uuid, type: String, desc: "Project uuid."
        end
        segment ":uuid" do
          
          resources :documents do
            
            get ":sha/pdf" do
              format = 'pdf'
              projects = Project.where(:uuid => params[:uuid])
              error!("Project with uuid #{params[:uuid]} is not found", 404) if projects.size == 0
              project = projects.first
              client = GitHubClient.new
              response = client.get "/repos/#{project.full_name}/git/blobs/#{params[:sha]}"
              if (response.ok?) 
                cd = CompiledDocument.create(
                  :project => project, 
                  :format => format, 
                  :sha => params[:sha])
                status, log = Cocowrite::DocumentConverter::run_pandoc response.body, "#{params[:sha]}.#{format}"
                cd.status = status
                cd.save!
                if cd.status_compilation_succeed?
                  cd.extend(CompiledDocumentRepresenter)
                else
                  error!("Document conversion failed.", 500)
                end
              else
                error!(response.data["message"], 404)
              end
            end
            
          end
          
        end
        
      end
      
    end
  end
end
2
