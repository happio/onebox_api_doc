require "rails_helper"

RSpec.describe OneboxApiDoc::ApplicationController, :type => :routing do
  routes { OneboxApiDoc::Engine.routes }

  describe "enable devise auth" do
    before :all do
      OneboxApiDoc::Engine.auth_service = :devise
    end
    it "route to sign in devise" do
      expect(:get => new_developer_session_path).
      to route_to(:controller => "my_engine/widgets", :action => "index")
    end
  end
  
end