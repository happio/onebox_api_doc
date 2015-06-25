require "rails_helper"

module OneboxApiDoc
  describe ApplicationController do

    routes { OneboxApiDoc::Engine.routes }

    describe "GET index" do

      before do
        @base = OneboxApiDoc.base
        @base.reload_document
      end

      it "set @all_tags"
      it "set @main_versions"
      it "set @default_version"
      it "set @main_app"
      it "set @current_version"
      it "set @apis_by_resources"
      it "set @api"

      # context "request with only version" do
      #   it "do not assigns @apis or @api" do
      #     get :index, { version: "1.2.3" }
      #     expect(assigns(:apis)).to eq nil
      #     expect(assigns(:api)).to eq nil
      #   end
      #   it "assigns @tags" do
      #     get :index, { version: "1.2.3" }
      #     tags = assigns(:tags)
      #     expect(tags).to be_an Array
      #     expect(tags.size).to be > 0
      #     tags.each do |tag|
      #       expect(tag).to be_an OneboxApiDoc::Tag
      #     end
      #   end
      #   it "assigns @versions" do
      #     get :index, { version: "1.2.3" }
      #     versions = assigns(:versions)
      #     expect(versions).to be_an Array
      #     expect(versions.size).to be > 0
      #     versions.each do |version|
      #       expect(version).to be_an OneboxApiDoc::Version
      #     end
      #   end
      #   it "assigns @apis_group_by_resources" do
      #     get :index, { version: "1.2.3" }
      #     apis_group_by_resources = assigns(:apis_group_by_resources)

      #     product_apis = @base.api_docs.select { |doc| doc._controller_name == "products" }.first._apis
      #     user_apis = @base.api_docs.select { |doc| doc._controller_name == "users" }.first._apis

      #     expect(apis_group_by_resources).to be_an Hash
      #     expect(apis_group_by_resources.keys.sort).to eq ["products", "users"].sort
      #     expect(apis_group_by_resources["products"]).to be_an Array
      #     expect(apis_group_by_resources["products"].size).to eq product_apis.size
      #     expect(apis_group_by_resources["products"].map { |api| api._url }.sort).to eq product_apis.map { |api| api._url }.sort
      #     expect(apis_group_by_resources["products"].map { |api| api._method }.sort).to eq product_apis.map { |api| api._method }.sort
      #     expect(apis_group_by_resources["products"].map { |api| api._action }.sort).to eq product_apis.map { |api| api._action }.sort
      #     expect(apis_group_by_resources["products"].map { |api| api._short_desc }.sort).to eq product_apis.map { |api| api._short_desc }.sort
      #     expect(apis_group_by_resources["users"]).to be_an Array
      #     expect(apis_group_by_resources["users"].size).to eq user_apis.size
      #     expect(apis_group_by_resources["users"].map { |api| api._url }.sort).to eq user_apis.map { |api| api._url }.sort
      #     expect(apis_group_by_resources["users"].map { |api| api._method }.sort).to eq user_apis.map { |api| api._method }.sort
      #     expect(apis_group_by_resources["users"].map { |api| api._action }.sort).to eq user_apis.map { |api| api._action }.sort
      #     expect(apis_group_by_resources["users"].map { |api| api._short_desc }.sort).to eq user_apis.map { |api| api._short_desc }.sort
      #   end
      # end

      # context "request with version and resource name" do
      #   it "assigns @apis" do
      #     get :index, { version: "1.2.3", resource_name: "products" }
      #     expect(assigns(:api)).to eq nil
      #     expect(assigns(:apis)).to be_an Array
      #     expect(assigns(:apis).size).to be > 0
      #   end
      #   it "assigns @tags" do
      #     get :index, { version: "1.2.3", resource_name: "products" }
      #     tags = assigns(:tags)
      #     expect(tags).to be_an Array
      #     expect(tags.size).to be > 0
      #     tags.each do |tag|
      #       expect(tag).to be_an OneboxApiDoc::Tag
      #     end
      #   end
      #   it "assigns @versions" do
      #     get :index, { version: "1.2.3", resource_name: "products" }
      #     versions = assigns(:versions)
      #     expect(versions).to be_an Array
      #     expect(versions.size).to be > 0
      #     versions.each do |version|
      #       expect(version).to be_an OneboxApiDoc::Version
      #     end
      #   end
      #   it "assigns @apis_group_by_resources" do
      #     get :index, { version: "1.2.3", resource_name: "products" }
      #     apis_group_by_resources = assigns(:apis_group_by_resources)

      #     product_apis = @base.api_docs.select { |doc| doc._controller_name == "products" }.first._apis
      #     user_apis = @base.api_docs.select { |doc| doc._controller_name == "users" }.first._apis

      #     expect(apis_group_by_resources).to be_an Hash
      #     expect(apis_group_by_resources.keys.sort).to eq ["products", "users"].sort
      #     expect(apis_group_by_resources["products"]).to be_an Array
      #     expect(apis_group_by_resources["products"].size).to eq product_apis.size
      #     expect(apis_group_by_resources["products"].map { |api| api._url }.sort).to eq product_apis.map { |api| api._url }.sort
      #     expect(apis_group_by_resources["products"].map { |api| api._method }.sort).to eq product_apis.map { |api| api._method }.sort
      #     expect(apis_group_by_resources["products"].map { |api| api._action }.sort).to eq product_apis.map { |api| api._action }.sort
      #     expect(apis_group_by_resources["products"].map { |api| api._short_desc }.sort).to eq product_apis.map { |api| api._short_desc }.sort
      #     expect(apis_group_by_resources["users"]).to be_an Array
      #     expect(apis_group_by_resources["users"].size).to eq user_apis.size
      #     expect(apis_group_by_resources["users"].map { |api| api._url }.sort).to eq user_apis.map { |api| api._url }.sort
      #     expect(apis_group_by_resources["users"].map { |api| api._method }.sort).to eq user_apis.map { |api| api._method }.sort
      #     expect(apis_group_by_resources["users"].map { |api| api._action }.sort).to eq user_apis.map { |api| api._action }.sort
      #     expect(apis_group_by_resources["users"].map { |api| api._short_desc }.sort).to eq user_apis.map { |api| api._short_desc }.sort
      #   end
      # end

      # context "request with version, resource name and action" do
      #   it "assigns @api" do
      #     get :index, { version: "1.2.3", resource_name: "products", action_name: "index" }
      #     expect(assigns(:apis)).to eq nil
      #     expect(assigns(:api)).to be_an OneboxApiDoc::Api
      #   end
      #   it "assigns @tags" do
      #     get :index, { version: "1.2.3", resource_name: "products", action_name: "index" }
      #     tags = assigns(:tags)
      #     expect(tags).to be_an Array
      #     expect(tags.size).to be > 0
      #     tags.each do |tag|
      #       expect(tag).to be_an OneboxApiDoc::Tag
      #     end
      #   end
      #   it "assigns @versions" do
      #     get :index, { version: "1.2.3", resource_name: "products", action_name: "index" }
      #     versions = assigns(:versions)
      #     expect(versions).to be_an Array
      #     expect(versions.size).to be > 0
      #     versions.each do |version|
      #       expect(version).to be_an OneboxApiDoc::Version
      #     end
      #   end
      #   it "assigns @apis_group_by_resources" do
      #     get :index, { version: "1.2.3", resource_name: "products", action_name: "index" }
      #     apis_group_by_resources = assigns(:apis_group_by_resources)

      #     product_apis = @base.api_docs.select { |doc| doc._controller_name == "products" }.first._apis
      #     user_apis = @base.api_docs.select { |doc| doc._controller_name == "users" }.first._apis

      #     expect(apis_group_by_resources).to be_an Hash
      #     expect(apis_group_by_resources.keys.sort).to eq ["products", "users"].sort
      #     expect(apis_group_by_resources["products"]).to be_an Array
      #     expect(apis_group_by_resources["products"].size).to eq product_apis.size
      #     expect(apis_group_by_resources["products"].map { |api| api._url }.sort).to eq product_apis.map { |api| api._url }.sort
      #     expect(apis_group_by_resources["products"].map { |api| api._method }.sort).to eq product_apis.map { |api| api._method }.sort
      #     expect(apis_group_by_resources["products"].map { |api| api._action }.sort).to eq product_apis.map { |api| api._action }.sort
      #     expect(apis_group_by_resources["products"].map { |api| api._short_desc }.sort).to eq product_apis.map { |api| api._short_desc }.sort
      #     expect(apis_group_by_resources["users"]).to be_an Array
      #     expect(apis_group_by_resources["users"].size).to eq user_apis.size
      #     expect(apis_group_by_resources["users"].map { |api| api._url }.sort).to eq user_apis.map { |api| api._url }.sort
      #     expect(apis_group_by_resources["users"].map { |api| api._method }.sort).to eq user_apis.map { |api| api._method }.sort
      #     expect(apis_group_by_resources["users"].map { |api| api._action }.sort).to eq user_apis.map { |api| api._action }.sort
      #     expect(apis_group_by_resources["users"].map { |api| api._short_desc }.sort).to eq user_apis.map { |api| api._short_desc }.sort
      #   end
      # end
    end

  end
end