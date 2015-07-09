module OneboxApiDoc
  class Route

    @all_api_routes

    class << self

      def route_for controller_name, action
        route = all_api_routes.select{ |route| route[:reqs] == "#{controller_name}##{action}" }.first
        route[:path] = route[:path].gsub(/\(.*\)/, "") if route.present?
        route
      end

      def all_api_routes
        @all_api_routes ||= get_all_api_routes
      end

      # def get_all_api_routes
      #   routes = Rails.application.routes.routes
      #   routes.collect do |route|
      #     ActionDispatch::Routing::RouteWrapper.new(route)
      #   end.reject do |route|
      #     route.internal?
      #   end.collect do |route|
      #     { name:   route.name,
      #       method:   route.verb,
      #       path:   route.path,
      #       reqs:   route.reqs,
      #       regexp: route.json_regexp }
      #   end
      # end
      private
        def get_all_api_routes
          all_routes_from_app_and_engines = []

          all_routes = Rails.application.routes.routes
          require 'action_dispatch/routing/inspector'
          inspector = ActionDispatch::Routing::RoutesInspector.new(all_routes)
          routes_to_display = inspector.send(:filter_routes, ENV['CONTROLLER'])
          all_routes = inspector.send(:collect_routes, routes_to_display)

          # app routes
          app_routes = get_routes_app(all_routes)
          app_routes.each do |route|
            all_routes_from_app_and_engines << route
          end

          # engines routes
          engines = inspector.instance_variable_get :@engines
          engines.each do |name, engine_routes|
            prefix_path = get_prifix_engine_route(all_routes, name)
            all_routes_from_app_and_engines += get_routes_engine(engine_routes, prefix_path)
          end

          # change formatt
          all_routes_from_app_and_engines.collect do |route|
            { 
              name:   route[:name],
              method: route[:verb],
              path:   route[:path],
              reqs:   route[:reqs]
            }
          end
        end

        def get_prifix_engine_route all_routes, engine_name
          all_routes.detect { |route| route[:reqs] == engine_name }[:path]
        end

        def get_routes_app all_routes
          all_routes.select { |route| not route[:reqs].ends_with?("::Engine") }
        end

        def get_routes_engine engine_routes, prefix_path
          routes = []
          engine_routes.each do |route|
            routes << route
          end

          routes.collect do |route|
            { 
              name:   route[:name],
              method: route[:verb],
              path:   "#{prefix_path}#{route[:path]}",
              reqs:   route[:reqs]
            }
          end

        end


    end

  end
end
