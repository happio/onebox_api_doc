require "rails_helper"

module OneboxApiDoc
  describe Tag do
    describe "initialize" do
      it "set correct name and init blank apis" do
        tag = OneboxApiDoc::Tag.new :new_tag
        expect(tag).not_to eq nil
        expect(tag.name).to eq "new_tag"
      end
    end
  end
end