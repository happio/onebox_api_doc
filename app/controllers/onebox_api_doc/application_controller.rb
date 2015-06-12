module OneboxApiDoc
  class ApplicationController < ActionController::Base

    def index
      base = OneboxApiDoc.base
      base.reload_documentation

      # set all tags
      @tags = base.all_tags

      # set all versions
      @versions = base.core_versions

      if api_params[:version].present?

        # set apis group by resource
        @apis_group_by_resources = base.get_version(api_params[:version]).apis_group_by_resources

        # set display api(s)
        if api_params[:resource_name].present? and api_params[:action_name].present?
          @api = base.get_api(api_params[:version], api_params[:resource_name], api_params[:action_name])
        elsif api_params[:resource_name].present?
          @apis = base.get_api(api_params[:version], api_params[:resource_name])
        end
      end
      # render nothing: true
    end

    private

    def api_params
      params.permit(:version, :resource_name, :action_name)
    end
  end
end
