module OneboxApiDoc
  class ApplicationController < ActionController::Base

    def index
      @base = OneboxApiDoc.base
      @base.reload_document

      @core_version = @base.default_version

      @doc = @base.get_doc(@core_version.name)

      @tags = @base.get_tags(@core_version)
      @tag_target = @tags.detect { |tag| tag.name == tag: params[:role] }
      @resources =  if @tag_target
                      @tag_target.apis_group_by_resource
                    else
                       @doc.apis_group_by_resource
                    end
    end

    def show
      @base = OneboxApiDoc.base
      @core_version = @base.default_version
      api_options = {
        version: api_params[:version] || @core_version.name,
        resource_name: api_params[:resource_name],
        action_name: api_params[:action_name]
      }
      # if api_params[:version].present?
      # # set all core versions
      # @main_versions = base.main_versions

      # # set all extension version
      # # @extension_versions = base.extension_versions

      # # set default version
      # @default_version = base.default_version

      # # set main app
      # @main_app = base.main_app

      # # set extension apps
      # # @extensions = base.extension_apps

      # # set current version
      # if api_params[:version].present?
      #   @current_version = base.get_version(api_params[:version])
      # else
      #   @current_version = @default_version
      # end

      # # set tags of version
      # @tags = base.get_tags(@current_version)

      # # set apis group by resource
      # @apis_group_by_resource = base.apis_group_by_resource(@current_version)

      # # set display api(s)
      @api = @base.get_api(api_options)

    end

    def example
      
    end

    private

    def api_params
      params.permit(:version, :resource_name, :action_name)
    end
  end
end
