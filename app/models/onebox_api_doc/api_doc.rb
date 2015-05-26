module OneboxApiDoc
  class ApiDoc

    @_controller_name
    @_version
    @_apis = []
    @all_api_paths

    class << self

      ##############################
      ####### Getter Methods #######
      ##############################

      def _controller_name
        @_controller_name
      end

      def _version
        @_version
      end

      def _apis
        @_apis
      end

      ##############################
      ####### Setter Methods #######
      ##############################

      def controller_name name
        name ||= self.class.name.demodulize.underscore
        @_controller_name = name.to_s
      end

      # for extension
      def extension_name name
      end

      # core_version is for extension
      def version name, core_version: {}
        @_version = name.to_s
      end

      def api action, short_desc="", &block
        @_apis ||= []
        @_apis << OneboxApiDoc::Api.new(@_controller_name, action, short_desc, &block)
      end

      ##############################
      ####### Other Methods #######
      ##############################

      def url_for controller_name, action
        route = all_api_routes.select{ |route| route[:reqs] == "#{controller_name}##{action}" }.first
        route[:path].gsub(/\(.*\)/, "") if route.present?
      end

      def method_for controller_name, action
        route = all_api_routes.select{ |route| route[:reqs] == "#{controller_name}##{action}" }.first
        route[:method] if route.present?
      end

      def all_api_routes
        @all_api_routes ||= get_all_api_routes
      end

      def get_all_api_routes
        routes = Rails.application.routes.routes
        routes.collect do |route|
          ActionDispatch::Routing::RouteWrapper.new(route)
        end.reject do |route|
          route.internal?
        end.collect do |route|
          { name:   route.name,
            method:   route.verb,
            path:   route.path,
            reqs:   route.reqs,
            regexp: route.json_regexp }
        end
      end
    end
    
  end
end