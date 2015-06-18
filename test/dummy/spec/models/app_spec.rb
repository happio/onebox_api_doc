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
      end
    end

    describe "is_extension?" do
      it "return false if app name is main" do
        app = OneboxApiDoc::App.new :main
        expect(app.is_extension?).to eq false
      end
      it "return true if app name is not main" do
        app = OneboxApiDoc::App.new :not_main
        expect(app.is_extension?).to eq true
      end
    end
  end
end