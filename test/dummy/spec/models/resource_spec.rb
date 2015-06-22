require "rails_helper"

module OneboxApiDoc
  describe Resource do
    before do
      @base = OneboxApiDoc.base
    end

    describe "initialize" do
      it "set correct id and name" do
        resource = OneboxApiDoc::Resource.new name: :new_resource
        expect(resource).not_to eq nil
        expect(resource.name).to eq "new_resource"
      end
    end
  end
end