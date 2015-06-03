require "rails_helper"

module OneboxApiDoc
  describe Tag do
    
    describe "find_or_initialize" do
      it "create a new tag if tag with given name does not exist" do
        expect(OneboxApiDoc::Tag).to receive(:new)
        new_tag = OneboxApiDoc::Tag.find_or_initialize :new_tag
      end
      it "do not create a new tag if tag with given name already not exist" do
        tag = OneboxApiDoc::Tag.new :new_tag
        expect(OneboxApiDoc::Tag).not_to receive(:new)
        OneboxApiDoc::Tag.find_or_initialize :new_tag
      end
    end

    describe "initialize" do
      it "set correct name and init blank apis" do
        tag = OneboxApiDoc::Tag.new :new_tag
        expect(tag).not_to eq nil
        expect(tag.name).to eq "new_tag"
      end
    end
  end
end