require "rails_helper"

module OneboxApiDoc
  describe Tag do
    # describe "initialize" do
    #   it "set correct name and init blank apis" do
    #     tag = OneboxApiDoc::Tag.new :new_tag
    #     expect(tag).not_to eq nil
    #     expect(tag.name).to eq "new_tag"
    #   end
    # end

    # describe "apis_by_resources" do
    #   it "return apis based on resource name" do
    #     tag = OneboxApiDoc::Tag.new :mobile
    #     user_api1 = OneboxApiDoc::Api.new(:users, :show)
    #     user_api2 = OneboxApiDoc::Api.new(:users, :update)
    #     product_api1 = OneboxApiDoc::Api.new(:products, :index)
    #     product_api2 = OneboxApiDoc::Api.new(:products, :create)
    #     product_api3 = OneboxApiDoc::Api.new(:products, :show)
    #     product_api4 = OneboxApiDoc::Api.new(:products, :update)
    #     product_api5 = OneboxApiDoc::Api.new(:products, :destroy)
    #     tag.apis = [user_api1, user_api2, product_api1, product_api2, product_api3, product_api4, product_api5]
    #     apis_by_resources = tag.apis_by_resources
    #     expect(apis_by_resources).to be_a Hash
    #     expect(apis_by_resources.keys).to eq ["users", "products"]
    #     user_apis = apis_by_resources["users"]
    #     expect(user_apis).to be_an Array
    #     expect(user_apis).to eq [user_api1, user_api2]
    #     product_apis = apis_by_resources["products"]
    #     expect(product_apis).to be_an Array
    #     expect(product_apis).to eq [product_api1, product_api2, product_api3, product_api4, product_api5]
    #   end
    # end

    before do
      @base = OneboxApiDoc.base
    end

    describe "initialize" do
      it "set correct id and name" do
        tag = OneboxApiDoc::Tag.new :new_tag
        expect(tag).not_to eq nil
        expect(tag.name).to eq "new_tag"
      end
    end
  end
end