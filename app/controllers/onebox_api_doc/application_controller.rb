module OneboxApiDoc
  class ApplicationController < ActionController::Base

    before_action :authenticate_developer!

    caches_action :index
    caches_action :show, :cache_path => Proc.new { |controller| controller.params.except(:_).merge(format: request.format) }

    before_action :reload_document

    def reload_document
      @base = OneboxApiDoc.base
      unless @base.versions.present? and (not params[:reload_document])
        @base.reload_document
      end
    end

    def index
      @current_version = @base.default_version

      @doc = @base.get_doc(@current_version.name)
      @tags = @base.get_tags(@current_version)
      @current_tag = @tags.detect { |tag| tag.slug == api_params[:tag].try(:downcase) } || @tags.first
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
      api_options = {
        version: api_params[:version] || @base.default_version.name,
        tag: api_params[:tag],
        resource_name: api_params[:resource_name],
        method: api_params[:method],
        url: api_params[:url]
      }
      unless request.xhr?
        @doc = @base.get_doc(api_options[:version])
        @current_version = @doc.version
        @tags = @base.get_tags(@current_version)
        @current_tag = @tags.detect { |tag| tag.slug == api_params[:tag].downcase }
        @resources = @current_tag.apis_group_by_resource
      end

      @api = @base.get_api(api_options)

      respond_to do |format|
        format.html
        format.js do 
          response = { 
            url: request.original_url, 
            html: render_to_string(partial: 'onebox_api_doc/application/api_details', locals: { api: @api }, layout: false)
          }
          render json: response
        end
      end

    end

    def example
      
    end

    private

    def api_params
      params.permit(:version, :tag, :resource_name, :method, :url)
    end
  end
end
