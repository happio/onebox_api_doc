require "rails_helper"

module OneboxApiDoc
  describe Object do
    before do
      @base = OneboxApiDoc.base
    end

    describe "initialize" do
      it "set correct id" do
        object = OneboxApiDoc::Object.new :new_obj
        expect(object).not_to eq nil
        expect(object.id).to eq 1
        expect(@base.index[:object]).to eq 1
      end
    end
  end
end