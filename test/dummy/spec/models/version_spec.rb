require "rails_helper"

module OneboxApiDoc
  describe Version do
    describe "initialize" do
      it "set correct version and default value for apis" do
        version = OneboxApiDoc::Version.new "0.0.4"
        expect(version).not_to eq nil
        expect(version.version).to eq "0.0.4"
        expect(version.apis).to eq []
      end
      it "set correct version and extension name if given" do
        version = OneboxApiDoc::Version.new "0.0.4", :my_extension
        expect(version).not_to eq nil
        expect(version.version).to eq "0.0.4"
        expect(version.extension_name).to eq "my_extension"
        expect(version.apis).to eq []
      end
    end

    describe "is_extension?" do
      it "return true if the version is an extension version" do
        extension_version = OneboxApiDoc::Version.new "0.0.2", :my_extension
        expect(extension_version.is_extension?).to eq true
      end
      it "return false if the version is a core version" do
        core_version = OneboxApiDoc::Version.new "0.0.4"
        expect(core_version.is_extension?).to eq false
      end
    end

    describe "get_api" do
      before do
        @base = OneboxApiDoc.base
        @base.load_documentation
        @version = @base.core_versions.select { |v| v.version == "1.2.3" }.first
      end
      it "return correct api" do
        api = @version.get_api(:products, :update)
        expect(api).not_to eq nil
        api_doc = @base.api_docs.select { |doc| doc._controller_name == "products" and doc._version.version == "1.2.3" }.first
        expect(api_doc._apis).to include api
        expect(api._controller_name).to eq "products"
        expect(api._action).to eq "update"
      end
      it "return nil if resource name not found" do
        fake_api = @version.get_api(:fake_resources, :update)
        expect(fake_api).to eq nil
      end
      it "return nil if action name not found" do
        fake_api = @version.get_api(:products, :fake_action)
        expect(fake_api).to eq nil
      end
    end
  end
end