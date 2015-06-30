require "rails_helper"

module OneboxApiDoc
  describe Version do

    before do
      @base = OneboxApiDoc.base
    end

    describe "initialize" do
      it "set correct name and app_id" do
        version = OneboxApiDoc::Version.new name: "0.0.4", app_id: 12
        expect(version).not_to eq nil
        expect(version.name).to eq "0.0.4"
        expect(version.app_id).to eq 12
      end
    end

    describe "is_extension?" do
      it "return true if the version's app is an extension version" do
        extension_app = @base.add_app("extension")
        extension_version = OneboxApiDoc::Version.new name: "0.0.2", app_id: extension_app.object_id
        expect(extension_version.is_extension?).to eq true
      end
      it "return false if the version's app is a core version" do
        main_app = @base.add_app("main")
        core_version = OneboxApiDoc::Version.new name: "0.0.4", app_id: main_app.object_id
        expect(core_version.is_extension?).to eq false
      end
    end

    describe "app" do
      it "return correct app" do
        main_app = @base.add_app("main")
        version = OneboxApiDoc::Version.new name: "0.0.4", app_id: main_app.object_id
        expect(version.app).to eq main_app
      end
    end

  end
end