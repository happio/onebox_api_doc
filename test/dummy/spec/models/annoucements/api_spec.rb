require "rails_helper"

module OneboxApiDoc
  module Annoucements
    describe Api do
      before :all do
        class AnnoucementsApiDoc < OneboxApiDoc::ApiDoc
          version "0.99"
          resource_name :users
          get '/users/:id', 'test' do
            warning 'new api'
          end
        end
      end
      before do
        @base = OneboxApiDoc.base
        @doc = @base.docs.last
        @api = @doc.apis.first
        @annoucement = OneboxApiDoc::Annoucements::Api.new(doc_id: @doc.object_id, api_id: @api.object_id)
      end

      describe "initialize" do
        it "set correct doc_id" do
          expect(@annoucement.doc.object_id).to eq @doc.object_id
        end
        it "set correct api_id" do
          expect(@annoucement.api.object_id).to eq @api.object_id
        end
      end

      it "message from param's waring" do
        expect(@annoucement.message).to eq @api.warning
      end
    end
  end
  
end