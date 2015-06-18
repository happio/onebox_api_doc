require "rails_helper"

module OneboxApiDoc
  describe Error do
    before do
      @base = OneboxApiDoc.base
    end

    describe "initialize" do
      it "set correct code and message" do
        error = OneboxApiDoc::Error.new 404, "Not Found"
        expect(error).not_to eq nil
        expect(error.code).to eq 404
        expect(error.message).to eq "Not Found"
      end
      it "set correct code, message, permission_ids and param_ids" do
        error = OneboxApiDoc::Error.new 404, "Not Found", [1,3,5], [2,4,6]
        expect(error).not_to eq nil
        expect(error.code).to eq 404
        expect(error.message).to eq "Not Found"
        expect(error.permission_ids).to eq [1,3,5]
        expect(error.param_ids).to eq [2,4,6]
      end
    end
  end
end