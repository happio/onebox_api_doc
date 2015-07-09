require "rails_helper"

module OneboxApiDoc
  describe Route do

    describe "route_for" do
      it "return correct route" do
        expected_route = {
          name: "user",
          method: "GET",
          path: "/users/:id",
          reqs: "users#show"
        }
        expect(OneboxApiDoc::Route.route_for :users, :show).to eq expected_route
      end
      it "return nil if trying to get unknown route" do
        expect(OneboxApiDoc::Route.route_for :fakes, :fake).to eq nil
      end
    end

    describe "get_all_api_routes" do
      it "return api routes with correct keys" do
        routes = OneboxApiDoc::Route.send(:get_all_api_routes)
        expect(routes.size).to be > 0
        routes.each do |route|
          expect(route.keys).to include(:name).
            and(include :method).and(include(:path)).
            and(include(:reqs))
        end
      end
    end

  end
end