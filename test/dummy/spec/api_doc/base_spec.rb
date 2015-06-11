require "rails_helper"

module OneboxApiDoc
  describe Base do

    let(:base) { OneboxApiDoc::Base.new }

    describe "reload_documentation" do
      it "unload document and load it again" do
        expect(base).to receive :load_documentation
        expect(base).to receive :unload_documentation
        base.reload_documentation
      end
    end

    describe "load_documentation" do
      it "load document class" do
        base.load_documentation
        expect{ UsersApiDoc }.not_to raise_error
      end
    end

    describe "unload_documentation" do
      it "does not load document class if the class wasn't load yet" do
        base.unload_documentation
        expect{ UsersApiDoc }.to raise_error
      end
      it "unload document class if the class was loaded" do
        base.load_documentation
        base.unload_documentation
        expect{ UsersApiDoc }.to raise_error
      end
      it "reset attributes to default value" do
        expect(base).to receive :set_default_value
        base.unload_documentation
      end
    end

    describe "api_docs_paths" do
      it "return correct array of document paths" do
        expect(base.api_docs_paths).to eq Dir.glob(Rails.root.join(*OneboxApiDoc::Engine.api_docs_matcher.split("/")))
      end
    end

    describe "api_docs" do
      it "return all api doc classes" do
        expected_api_docs = OneboxApiDoc::ApiDoc.subclasses
        expect(base.api_docs).to eq expected_api_docs
      end
    end

    describe "get_api" do
      before do
        @base = OneboxApiDoc.base
        @base.reload_documentation
      end
      it "return correct api when request with resource name and action name" do
        get_all_product_api = @base.get_api("1.2.3", :products, :index)
        expect(get_all_product_api).not_to eq nil
        expect(get_all_product_api._controller_name).to eq "products"
        expect(get_all_product_api._action).to eq "index"
      end
      it "return correct array of api when request with only resource name" do
        product_apis = @base.get_api("1.2.3", :products)
        expect(product_apis).not_to eq nil
        expect(product_apis).to be_an Array
        api_doc = @base.api_docs.select { |doc| doc._controller_name == "products" and doc._version.version == "1.2.3" }.first
        expected_apis = api_doc._apis
        product_apis.each do |api|
          expect(api._controller_name).to eq "products"
        end
        expect(product_apis.map { |api| api._controller_name }.sort).to eq expected_apis.map { |api| api._controller_name }.sort
        expect(product_apis.map { |api| api._action }.sort).to eq expected_apis.map { |api| api._action }.sort
        expect(product_apis.map { |api| api._url }.sort).to eq expected_apis.map { |api| api._url }.sort
        expect(product_apis.map { |api| api._method }.sort).to eq expected_apis.map { |api| api._method }.sort
        expect(product_apis.map { |api| api._short_desc }.sort).to eq expected_apis.map { |api| api._short_desc }.sort
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
        base.add_tag :new_tag
        expect(base.all_tags.size).to eq 1
        expect(base.all_tags.map(&:name)).to include "new_tag"
      end
      it "does not add tag with duplicate name" do
        base.add_tag :new_tag
        base.add_tag :new_tag
        expect(base.all_tags.size).to eq 1
        expect(base.all_tags.map(&:name)).to include "new_tag"
      end
    end

    describe "add_api" do
      it "add api to @all_apis" do
        api = OneboxApiDoc::Api.new(:products, :index)
        base.add_api api
        expect(base.all_apis.size).to eq 1
        expect(base.all_apis).to include api
      end
      it "does not add duplicate api to @all_apis" do
        api = OneboxApiDoc::Api.new(:products, :index)
        base.add_api api
        base.add_api api
        expect(base.all_apis.size).to eq 1
        expect(base.all_apis).to include api
      end
    end

    describe "add_version" do
      it "add version to @core_versions" do
        base.add_version "1.2"
        expect(base.core_versions.size).to eq 1
        expect(base.core_versions.map(&:version)).to include "1.2"
      end
      it "does not add version with duplicate name" do
        base.add_version "1.2"
        base.add_version "1.2"
        expect(base.core_versions.size).to eq 1
        expect(base.core_versions.map(&:version)).to include "1.2"
      end
    end

    describe "add_extension_version" do
      it "add extension version to @extension_versions" do
        base.add_extension_version :extension_name, "1.2"
        expect(base.extension_versions["extension_name"].size).to eq 1
        expect(base.extension_versions["extension_name"].map(&:version)).to include "1.2"
      end
      it "does not add extension version with duplicate name" do
        base.add_extension_version :extension_name, "1.2"
        base.add_extension_version :extension_name, "1.2"
        expect(base.extension_versions["extension_name"].size).to eq 1
        expect(base.extension_versions["extension_name"].map(&:version)).to include "1.2"
      end
    end

    describe "add_permission" do
      it "add permission to @all_permissions" do
        base.add_permission :admin
        expect(base.all_permissions.size).to eq 1
        expect(base.all_permissions).to include "admin"
      end
      it "do not add duplicate permission to @all_permissions" do
        base.add_permission "admin"
        base.add_permission :admin
        expect(base.all_permissions.size).to eq 1
        expect(base.all_permissions).to include "admin"
      end
    end

    describe "add_param_group" do
      it "add param group" do
        base.add_param_group :sample do
          puts "do something"
        end
        expect(base.param_groups.keys).to include "sample"
        expect(base.param_groups["sample"]).to be_a Proc
      end
    end

    describe "get_param_group" do
      before do
        @block = Proc.new { puts "do something" }
        base.param_groups["sample"] = @block
      end
      it "return correct proc" do
        param_group = base.get_param_group :sample
        expect(param_group).to be_a Proc
        expect(param_group).to eq @block
      end
      
    end

  end
end