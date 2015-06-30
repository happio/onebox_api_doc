module OneboxApiDoc
  class ApplicationController < ActionController::Base

    def index
      @base = OneboxApiDoc.base
      @base.reload_document

      @current_version = @base.default_version

      @doc = @base.get_doc(@current_version.name)

      @tags = @base.get_tags(@current_version)
      @current_tag = @tags.detect { |tag| tag.name == api_params[:tag].try(:downcase) } || @tags.first
      @resources =  if @current_tag
                      @current_tag.apis_group_by_resource
                    else
                       @doc.apis_group_by_resource
                    end
      respond_to do |format|
        format.html
        format.js
      end
    end

    def show
      @base = OneboxApiDoc.base
      api_options = {
        version: api_params[:version] || @base.default_version.name,
        tag: api_params[:tag],
        resource_name: api_params[:resource_name],
        action_name: api_params[:action_name]
      }
      unless request.xhr?
        @doc = @base.get_doc(api_options[:version])
        @tags = @base.get_tags(@doc.version)
        @current_tag = @tags.detect { |tag| tag.name == api_params[:tag].downcase }
        @resources = @current_tag.apis_group_by_resource
      end

      @api = @base.get_api(api_options)

      respond_to do |format|
        format.html
        format.js
      end

    end

    def example
      
    end

    private

    def api_params
      params.permit(:version, :tag, :resource_name, :action_name)
    end
  end
end
