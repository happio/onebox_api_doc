require "rails_helper"

module OneboxApiDoc
  describe Permission do
    before do
      @base = OneboxApiDoc.base
    end

    describe "initialize" do
      it "set correct id and name" do
        permission = OneboxApiDoc::Permission.new name: :new_permission
        expect(permission).not_to eq nil
        expect(permission.name).to eq "new_permission"
      end
    end
  end
end