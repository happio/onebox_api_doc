require "rails_helper"

module OneboxApiDoc
  describe Error do
    before do
      @base = OneboxApiDoc.base
    end

    describe "initialize" do
      it "set correct doc_id, code and message" do
        error = OneboxApiDoc::Error.new doc_id: 1, code: 404, message: "Not Found"
        expect(error).not_to eq nil
        expect(error.doc_id).to eq 1
        expect(error.code).to eq 404
        expect(error.message).to eq "Not Found"
      end
      it "set correct code, message, permission_ids and param_ids" do
        error = OneboxApiDoc::Error.new doc_id: 1, code: 404, message: "Not Found", permission_ids: [1,3,5], param_ids: [2,4,6]
        expect(error).not_to eq nil
        expect(error.code).to eq 404
        expect(error.message).to eq "Not Found"
        expect(error.permission_ids).to eq [1,3,5]
        expect(error.param_ids).to eq [2,4,6]
      end
    end

    describe "doc" do
      it "return correct doc"
    end

    describe "params" do
      it "return correct params array"
    end

    describe "permissions" do
      it "return correct permissions array"
    end

    describe "permissions=()" do
      it "set correct permission_ids"
    end
  end
end