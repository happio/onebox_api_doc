require "rails_helper"

module OneboxApiDoc
  describe Resource do
    before do
      @base = OneboxApiDoc.base
    end

    describe "initialize" do
      it "set correct id and name" do
        resource = OneboxApiDoc::Resource.new :new_resource
        expect(resource).not_to eq nil
        expect(resource.name).to eq "new_resource"
        expect(resource.id).to eq 1
        expect(@base.index[:resource]).to eq 1
      end
    end
  end
end