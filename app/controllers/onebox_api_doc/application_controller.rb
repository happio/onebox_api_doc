module OneboxApiDoc
  class ApplicationController < ActionController::Base

    def index
      base = OneboxApiDoc.base
      base.reload_documentation
      if api_params[:version].present?
        if api_params[:resource_name].present? and api_params[:action_name].present?
          @api = base.get_api(api_params[:version], api_params[:resource_name], api_params[:action_name])
        elsif api_params[:resource_name].present?
          @apis = base.get_api(api_params[:version], api_params[:resource_name])
        end
      end
      render nothing: true
    end

    private

    def api_params
      params.permit(:version, :resource_name, :action_name)
    end

  end
end
