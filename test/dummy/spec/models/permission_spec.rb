require "rails_helper"

module OneboxApiDoc
  describe Permission do
    before do
      @base = OneboxApiDoc.base
    end

    describe "initialize" do
      it "set correct id and name" do
        permission = OneboxApiDoc::Permission.new :new_permission
        expect(permission).not_to eq nil
        expect(permission.name).to eq "new_permission"
        expect(permission.id).to eq 1
        expect(@base.index[:permission]).to eq 1
      end
    end
  end
end