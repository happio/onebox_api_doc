require "rails_helper"

module OneboxApiDoc
  module Annoucements
    describe Param, focus: true do
      before :all do
        @base = OneboxApiDoc.reset
        class AnnoucementsApiDoc < OneboxApiDoc::ApiDoc
          version "0.99"
          resource_name :users
          api :update, 'test'
        end
      end
      before do
        @doc = @base.docs.last
        @param = @doc.add_param(:test_res_body, :string, warning: 'test_res_body')
        @annoucement = OneboxApiDoc::Annoucements::Param.new(doc_id: @doc.object_id, param_id: @param.object_id)
      end

      describe "initialize" do
        it "set correct doc_id" do
          expect(@annoucement.doc.object_id).to eq @doc.object_id
        end
        it "set correct param_id" do
          expect(@annoucement.param.object_id).to eq @param.object_id
        end
      end

      it "param" do
        expect(@annoucement.param).to eq @param
      end
      it "api" do
        expect(@annoucement.api).to eq @param.api
      end
      it "message from param's waring" do
        expect(@annoucement.message).to eq @param.warning
      end
    end
  end
  
end