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