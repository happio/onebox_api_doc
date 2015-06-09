require "rails_helper"

module OneboxApiDoc
  describe Base do

    describe "reload_documentation" do
      before do
        @base = OneboxApiDoc::Base.new
      end
      it "unload document and load it again" do
        expect(@base).to receive :load_documentation
        expect(@base).to receive :unload_documentation
        @base.reload_documentation
      end
    end

    describe "load_documentation" do
      before do
        @base = OneboxApiDoc::Base.new
      end
      it "load document class" do
        @base.load_documentation
        expect{ UsersApiDoc }.not_to raise_error
      end
    end

    describe "unload_documentation" do
      it "does not load document class if the class wasn't load yet" do
        OneboxApiDoc::Base.new.unload_documentation
        expect{ UsersApiDoc }.to raise_error
      end
      it "unload document class if the class was loaded" do
        base = OneboxApiDoc::Base.new
        base.load_documentation
        base.unload_documentation
        expect{ UsersApiDoc }.to raise_error
      end
      it "reset attributes to default value" do
        base = OneboxApiDoc::Base.new
        expect(base).to receive :set_default_value
        base.unload_documentation
      end
    end

    describe "api_docs_paths" do
      it "return correct array of document paths" do
        expect(OneboxApiDoc::Base.new.api_docs_paths).to eq Dir.glob(Rails.root.join(*OneboxApiDoc::Engine.api_docs_matcher.split("/")))
      end
    end

    describe "api_docs" do
      it "return all api doc classes" do
        expected_api_docs = OneboxApiDoc::ApiDoc.subclasses
        expect(OneboxApiDoc::Base.new.api_docs).to eq expected_api_docs
      end
    end

    describe "get_api" do
      before :each do
        @base = OneboxApiDoc.base
        @base.load_documentation
      end
      it "return correct api" do
        api_get_all_product = @base.get_api("1.2.3", :products, :index)
        expect(api_get_all_product).not_to eq nil
        expect(api_get_all_product._controller_name).to eq "products"
        expect(api_get_all_product._action).to eq "index"
      end
      it "return nil if version not found" do
        fake_api = @base.get_api("9.9.9", :products, :index)
        expect(fake_api).to eq nil
      end
      it "return nil if resource name not found" do
        fake_api = @base.get_api("1.2.3", :fake_resources, :index)
        expect(fake_api).to eq nil
      end
      it "return nil if action name not found" do
        fake_api = @base.get_api("1.2.3", :products, :fake_action)
        expect(fake_api).to eq nil
      end
    end

    describe "add_tag" do
      it "add tag to @all_tags" do
        base = OneboxApiDoc::Base.new
        base.add_tag :new_tag
        expect(base.all_tags.size).to eq 1
        expect(base.all_tags.map(&:name)).to include "new_tag"
      end
      it "does not add tag with duplicate name" do
        base = OneboxApiDoc::Base.new
        base.add_tag :new_tag
        base.add_tag :new_tag
        expect(base.all_tags.size).to eq 1
        expect(base.all_tags.map(&:name)).to include "new_tag"
      end
    end

    describe "add_api" do
      it "add api to @all_apis" do
        base = OneboxApiDoc::Base.new
        api = OneboxApiDoc::Api.new(:products, :index)
        base.add_api api
        expect(base.all_apis.size).to eq 1
        expect(base.all_apis).to include api
      end
      it "does not add duplicate api to @all_apis" do
        base = OneboxApiDoc::Base.new
        api = OneboxApiDoc::Api.new(:products, :index)
        base.add_api api
        base.add_api api
        expect(base.all_apis.size).to eq 1
        expect(base.all_apis).to include api
      end
    end

    describe "add_version" do
      it "add version to @core_versions" do
        base = OneboxApiDoc::Base.new
        base.add_version "1.2"
        expect(base.core_versions.size).to eq 1
        expect(base.core_versions.map(&:version)).to include "1.2"
      end
      it "does not add version with duplicate name" do
        base = OneboxApiDoc::Base.new
        base.add_version "1.2"
        base.add_version "1.2"
        expect(base.core_versions.size).to eq 1
        expect(base.core_versions.map(&:version)).to include "1.2"
      end
    end

    describe "add_extension_version" do
      it "add extension version to @extension_versions" do
        base = OneboxApiDoc::Base.new
        base.add_extension_version :extension_name, "1.2"
        expect(base.extension_versions["extension_name"].size).to eq 1
        expect(base.extension_versions["extension_name"].map(&:version)).to include "1.2"
      end
      it "does not add extension version with duplicate name" do
        base = OneboxApiDoc::Base.new
        base.add_extension_version :extension_name, "1.2"
        base.add_extension_version :extension_name, "1.2"
        expect(base.extension_versions["extension_name"].size).to eq 1
        expect(base.extension_versions["extension_name"].map(&:version)).to include "1.2"
      end
    end

    describe "add_permission" do
      it "add permission to @all_permissions" do
        base = OneboxApiDoc::Base.new
        base.add_permission :admin
        expect(base.all_permissions.size).to eq 1
        expect(base.all_permissions).to include "admin"
      end
      it "do not add duplicate permission to @all_permissions" do
        base = OneboxApiDoc::Base.new
        base.add_permission "admin"
        base.add_permission :admin
        expect(base.all_permissions.size).to eq 1
        expect(base.all_permissions).to include "admin"
      end
    end

    describe "add_param_group" do
      it "add param group" do
        base = OneboxApiDoc::Base.new
        base.add_param_group :sample do
          puts "do something"
        end
        expect(base.param_groups.keys).to include "sample"
        expect(base.param_groups["sample"]).to be_a Proc
      end
    end

    describe "get_param_group" do
      before do
        @base = OneboxApiDoc::Base.new
        @block = Proc.new { puts "do something" }
        @base.param_groups["sample"] = @block
      end
      it "return correct proc" do
        param_group = @base.get_param_group :sample
        expect(param_group).to be_a Proc
        expect(param_group).to eq @block
      end
      
    end

  end
end