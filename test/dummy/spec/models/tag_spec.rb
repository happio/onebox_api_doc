require "rails_helper"

module OneboxApiDoc
  describe Tag do

    before do
      class UsersApiDoc < ApiDoc
        controller_name :users
      end
      class ProductsApiDoc < ApiDoc
        controller_name :products
      end
    end

    describe "initialize" do
      it "set correct name and init blank apis" do
        tag = OneboxApiDoc::Tag.new :new_tag
        expect(tag).not_to eq nil
        expect(tag.name).to eq "new_tag"
      end
    end

    describe "apis_by_resources" do
      it "return apis based on resource name" do
        tag = OneboxApiDoc::Tag.new :mobile
        user_api1 = OneboxApiDoc::Api.new(UsersApiDoc, :show)
        user_api2 = OneboxApiDoc::Api.new(UsersApiDoc, :update)
        product_api1 = OneboxApiDoc::Api.new(ProductsApiDoc, :index)
        product_api2 = OneboxApiDoc::Api.new(ProductsApiDoc, :create)
        product_api3 = OneboxApiDoc::Api.new(ProductsApiDoc, :show)
        product_api4 = OneboxApiDoc::Api.new(ProductsApiDoc, :update)
        product_api5 = OneboxApiDoc::Api.new(ProductsApiDoc, :destroy)
        tag.apis = [user_api1, user_api2, product_api1, product_api2, product_api3, product_api4, product_api5]
        apis_by_resources = tag.apis_by_resources
        expect(apis_by_resources).to be_a Hash
        expect(apis_by_resources.keys).to eq ["users", "products"]
        user_apis = apis_by_resources["users"]
        expect(user_apis).to be_an Array
        expect(user_apis).to eq [user_api1, user_api2]
        product_apis = apis_by_resources["products"]
        expect(product_apis).to be_an Array
        expect(product_apis).to eq [product_api1, product_api2, product_api3, product_api4, product_api5]
      end
    end
  end
end