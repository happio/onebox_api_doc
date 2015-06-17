require "rails_helper"

module OneboxApiDoc
  describe App do
    before do
      @base = OneboxApiDoc.base
    end

    describe "initialize" do
      it "set correct id and name" do
        app = OneboxApiDoc::App.new :new_app
        expect(app).not_to eq nil
        expect(app.name).to eq "new_app"
        expect(app.id).to eq 1
        expect(@base.index[:app]).to eq 1
      end
    end
  end
end