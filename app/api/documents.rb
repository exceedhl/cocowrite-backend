require 'model/project'
require 'model/compiled-document'
require 'api/representer/compiled-document-representer'
require 'em-synchrony/em-http'
require 'util/document-converter'

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
              req = EM::HttpRequest.new("https://api.github.com/repos/#{project.full_name}/git/blobs/#{params[:sha]}").get
              if (req.response_header.status == 200) 
                cd = CompiledDocument.create(
                  :project => project, 
                  :format => format, 
                  :sha => params[:sha])
                status, log = Cocowrite::DocumentConverter::run_pandoc req.response, "#{params[:sha]}.#{format}"
                cd.status = status
                cd.save!

                cd.extend(CompiledDocumentRepresenter)
              else
                error!(JSON.parse(req.response)["message"], 404)
              end
            end
            
          end
          
        end
        
      end
      
    end
  end
end
2
