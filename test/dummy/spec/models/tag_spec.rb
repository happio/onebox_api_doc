require "rails_helper"

module OneboxApiDoc
  describe Tag do
    before do
      @base = OneboxApiDoc.base
    end

    describe "initialize" do
      it "set correct id and name" do
        tag = OneboxApiDoc::Tag.new name: :new_tag
        expect(tag).not_to eq nil
        expect(tag.name).to eq "new_tag"
      end
    end
  end
end