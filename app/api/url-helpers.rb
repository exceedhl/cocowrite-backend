module Cocowrite
  module API
    module UrlHelpers
      def rootUrl
        CONFIG['root_url']
      end
      
      def rootCompiledDocumentUrl
        CONFIG['document']['server_root_url']
      end

      def projects_url(uuid)
        "#{rootUrl}/projects/#{uuid}"
      end
      
      def compiled_document_url(cd)
        "#{rootCompiledDocumentUrl}/#{cd.sha}.#{cd.format}"
      end
    end
  end
end
