require "rails_helper"

module OneboxApiDoc
  describe Base do

    before do
      @base = OneboxApiDoc.base
      @base.send(:set_default_value)
      @base.unload_document
    end

    describe "initialize" do
      it "set default value" do
        expect_any_instance_of(OneboxApiDoc::Base).to receive :set_default_value
        OneboxApiDoc::Base.new
      end
      it "set correct default value" do
        expect(@base.apps).to eq []
        expect(@base.versions).to eq []
        expect(@base.docs).to eq []
        expect(@base.resources).to eq []
        expect(@base.params).to eq []
      end
    end

    describe "reload_document" do
      it "unload document and load it again" do
        expect(@base).to receive :load_document
        expect(@base).to receive :unload_document
        @base.reload_document
      end
    end

    describe "load_document", hhh: true do
      it "load document class" do
        @base.load_document
        expect{ UsersApiDoc }.not_to raise_error
      end
    end

    describe "unload_document" do
      it "does not load document class if the class wasn't load yet" do
        @base.unload_document
        expect{ UsersApiDoc }.to raise_error
      end
      it "unload document class if the class was loaded" do
        @base.load_document
        @base.unload_document
        expect{ UsersApiDoc }.to raise_error
      end
      it "reset attributes to default value" do
        expect(@base).to receive :set_default_value
        @base.unload_document
      end
    end

    describe "api_docs_paths" do
      it "return correct array of document paths" do
        expect(@base.api_docs_paths).to eq Dir.glob(Rails.root.join(*OneboxApiDoc::Engine.api_docs_matcher.split("/")))
      end
    end

    describe "main_app" do
      it "return correct app" do
        main_app = @base.main_app
        expect(main_app).to be_an OneboxApiDoc::App
        expect(main_app.name).to eq "main"
        expect(main_app.is_extension?).to eq false
      end
      it "add new app if main app not already exist" do
        @base.apps = []
        expect{ @base.main_app }.to change(@base.apps, :size).by 1
      end
      it "does not add new app if main app already exist" do
        @base.add_app "main"
        expect{ @base.main_app }.not_to change(@base.apps, :size)
      end
    end

    describe "extension_apps" do
      before do
        @base.add_app "extension1"
        @base.add_app "extension2"
      end
      it "return correct array of apps" do
        extension_apps = @base.extension_apps
        expect(extension_apps).to be_an Array
        expect(extension_apps.first).to be_an OneboxApiDoc::App
        expect(extension_apps.first.name).to eq 'extension1'
        expect(extension_apps.first.is_extension?).to eq true
        expect(extension_apps.second).to be_an OneboxApiDoc::App
        expect(extension_apps.second.name).to eq 'extension2'
        expect(extension_apps.second.is_extension?).to eq true
      end
    end

    describe "default_version" do
      it "return correct version" do
        default_version = @base.default_version
        expect(default_version).to be_an OneboxApiDoc::Version
        expect(default_version.name).to eq OneboxApiDoc::Engine.default_version
        expect(default_version.is_extension?).to eq false
        expect(default_version.app.name).to eq 'main'
      end
      it "add new version if main version not already exist" do
        @base.versions = []
        expect{ @base.default_version }.to change(@base.versions, :size).by 1
      end
      it "does not add new version if main version already exist" do
        @base.add_version OneboxApiDoc::Engine.default_version
        expect{ @base.default_version }.not_to change(@base.versions, :size)
      end
    end

    describe "get api" do
      before do
        @base.reload_document
      end
      context 'call with action' do
        it 'return correct api object' do
          api = @base.get_api(version: OneboxApiDoc::Engine.default_version, resource_name: :products, action_name: :index)
          expect(api).to be_an OneboxApiDoc::Api
          expect(api.action).to eq 'index'
          expect(api.resource.name).to eq 'products'
          expect(api.version).to eq @base.default_version
        end
        it 'return nil if version does not exist' do
          api = @base.get_api(version: 'fake version', resource_name: :products, action_name: :index)
          expect(api).to eq nil
        end
        it 'return nil if resource does not exist' do
          api = @base.get_api(version: @base.default_version.name, resource_name: :fake_resource, action_name: :index)
          expect(api).to eq nil
        end
        it 'return nil if action does not exist' do
          api = @base.get_api(version: @base.default_version.name, resource_name: :products, action_name: :fake_action)
          expect(api).to eq nil
        end
      end
      context 'call without action' do
        it 'return correct array of apis' do
          apis = @base.get_api(version: OneboxApiDoc::Engine.default_version, resource_name: :products)
          expect(apis).to be_an Array
          expect(apis.size).to be > 0
          apis.each do |api|
            expect(api).to be_an OneboxApiDoc::Api
            expect(api.resource.name).to eq 'products'
            expect(api.version).to eq @base.default_version
          end
        end
        it 'return blank array if version does not exist' do
          apis = @base.get_api(version: 'fake version', resource_name: :products)
          expect(apis).to eq []
        end
        it 'return blank array if resource does not exist' do
          apis = @base.get_api(version: @base.default_version.name, resource_name: :fake_resource)
          expect(apis).to eq []
        end
      end
    end

    describe "get_version" do
      before do
        @base.add_version "0.0.1"
      end
      it "return correct version" do
        version = @base.get_version "0.0.1"
        expect(version).not_to eq nil
        expect(version).to be_a OneboxApiDoc::Version
        expect(version.name).to eq "0.0.1"
      end
      it "return nil if version not found" do
        version = @base.get_version "0.0.9"
        expect(version).to eq nil
      end
    end

    describe "get_resource" do
      before do
        @base.add_resource :new_resource
      end
      it "return correct resource" do
        resource = @base.get_resource :new_resource
        expect(resource).not_to eq nil
        expect(resource).to be_a OneboxApiDoc::Resource
        expect(resource.name).to eq "new_resource"
      end
      it "return nil if resource not found" do
        resource = @base.get_resource :fake_resource
        expect(resource).to eq nil
      end
    end

    describe "get_doc" do
      before do
        @version = @base.default_version
        @base.add_doc @version.object_id
      end
      it "return correct doc" do
        doc = @base.get_doc @version.name
        expect(doc).not_to eq nil
        expect(doc).to be_a OneboxApiDoc::Doc
        expect(doc.version).to eq @version
      end
      it "return nil if version not found" do
        doc = @base.get_doc :fake_version
        expect(doc).to eq nil
      end
    end

    describe "get_app" do
      before do
        @base.add_app :new_app
      end
      it "return correct app" do
        app = @base.get_app :new_app
        expect(app).not_to eq nil
        expect(app).to be_a OneboxApiDoc::App
        expect(app.name).to eq "new_app"
      end
      it "return nil if app not found" do
        app = @base.get_app :fake_app
        expect(app).to eq nil
      end
    end

    describe "main_versions" do
      before do
        main_app = @base.add_app "main"
        @core_versions = []
        @core_versions << @base.add_version("0.0.2")
        @core_versions << @base.add_version("0.0.2.1")
        @core_versions << @base.add_version("0.0.2.2")
        @extension_versions = []
        @extension_versions << @base.add_extension_version("0.0.2", "extension_name")
        @extension_versions << @base.add_extension_version("0.1.2", "extension_name")
        @extension_versions << @base.add_extension_version("0.1.2.1", "extension_name")
        @extension_versions << @base.add_extension_version("1.0.2.2", "extension_name")
      end
      it "return array of version which belongs to main app" do
        versions = @base.main_versions
        expect(versions).to be_an Array
        expect(versions.size).to be > 0 and eq @core_versions.size
        versions.each do |version|
          expect(version.app.name).to eq "main"
          expect(version.is_extension?).to eq false
          expect(@extension_versions).not_to include version
        end
      end
    end

    describe "extension_versions" do
      before do
        main_app = @base.add_app "main"
        @core_versions = []
        @core_versions << @base.add_version("0.0.2")
        @core_versions << @base.add_version("0.0.2.1")
        @core_versions << @base.add_version("0.0.2.2")
        @extension_versions = []
        @extension_versions << @base.add_extension_version("0.0.2", "extension_name")
        @extension_versions << @base.add_extension_version("0.1.2", "extension_name")
        @extension_versions << @base.add_extension_version("0.1.2.1", "extension_name")
        @extension_versions << @base.add_extension_version("1.0.2.2", "extension_name")
      end
      it "return array of version which belongs to non-main app" do
        versions = @base.extension_versions
        expect(versions).to be_an Array
        expect(versions.size).to be > 0 and eq @extension_versions.size
        versions.each do |version|
          expect(version.app.name).not_to eq "main"
          expect(version.is_extension?).to eq true
          expect(@core_versions).not_to include version
        end
      end
    end

    # describe "get_api" do
      # before do
      #   @base = OneboxApiDoc.base
      #   @base.reload_document
      # end
      # it "return correct api when request with resource name and action name" do
      #   get_all_product_api = @base.get_api("1.2.3", :products, :index)
      #   expect(get_all_product_api).not_to eq nil
      #   expect(get_all_product_api._controller_name).to eq "products"
      #   expect(get_all_product_api._action).to eq "index"
      # end
      # it "return correct array of api when request with only resource name" do
      #   product_apis = @base.get_api("1.2.3", :products)
      #   expect(product_apis).not_to eq nil
      #   expect(product_apis).to be_an Array
      #   api_doc = @base.api_docs.select { |doc| doc._controller_name == "products" and doc._version.version == "1.2.3" }.first
      #   expected_apis = api_doc._apis
      #   product_apis.each do |api|
      #     expect(api._controller_name).to eq "products"
      #   end
      #   expect(product_apis.map { |api| api._controller_name }.sort).to eq expected_apis.map { |api| api._controller_name }.sort
      #   expect(product_apis.map { |api| api._action }.sort).to eq expected_apis.map { |api| api._action }.sort
      #   expect(product_apis.map { |api| api._url }.sort).to eq expected_apis.map { |api| api._url }.sort
      #   expect(product_apis.map { |api| api._method }.sort).to eq expected_apis.map { |api| api._method }.sort
      #   expect(product_apis.map { |api| api._short_desc }.sort).to eq expected_apis.map { |api| api._short_desc }.sort
      # end
      # it "return nil if version not found" do
      #   fake_api = @base.get_api("9.9.9", :products, :index)
      #   expect(fake_api).to eq nil
      # end
      # it "return nil if resource name not found" do
      #   fake_api = @base.get_api("1.2.3", :fake_resources, :index)
      #   expect(fake_api).to eq nil
      # end
      # it "return nil if action name not found" do
      #   fake_api = @base.get_api("1.2.3", :products, :fake_action)
      #   expect(fake_api).to eq nil
      # end
    # end

    # describe "get_tag" do
    #   before do
    #     base.add_tag :new_tag
    #   end
    #   it "return correct tag" do
    #     tag = base.get_tag :new_tag
    #     expect(tag).not_to eq nil
    #     expect(tag.name).to eq "new_tag"
    #   end
    #   it "return nil if tag not found" do
    #     tag = base.get_tag :fake_tag
    #     expect(tag).to eq nil
    #   end
    # end

    # describe "add_tag" do
    #   it "add tag to @all_tags" do
    #     base.add_tag :new_tag
    #     expect(base.all_tags.size).to eq 1
    #     expect(base.all_tags.map(&:name)).to include "new_tag"
    #   end
    #   it "does not add tag with duplicate name" do
    #     base.add_tag :new_tag
    #     base.add_tag :new_tag
    #     expect(base.all_tags.size).to eq 1
    #     expect(base.all_tags.map(&:name)).to include "new_tag"
    #   end
    # end

    # describe "add_api" do
    #   it "add api to @all_apis" do
    #     api = OneboxApiDoc::Api.new(:products, :index)
    #     base.add_api api
    #     expect(base.all_apis.size).to eq 1
    #     expect(base.all_apis).to include api
    #   end
    #   it "does not add duplicate api to @all_apis" do
    #     api = OneboxApiDoc::Api.new(:products, :index)
    #     base.add_api api
    #     base.add_api api
    #     expect(base.all_apis.size).to eq 1
    #     expect(base.all_apis).to include api
    #   end
    # end

    describe "add_resource" do
      before do
        @base.resources = []
      end
      it "add resource to array resources" do
        expect{ @base.add_resource :new_resource }.to change(@base.resources, :size).by 1
      end
      it "does not add array resource to resources if resource with the same name already exist" do
        @base.add_resource :new_resource
        expect{ @base.add_resource :new_resource }.not_to change(@base.resources, :size)
      end
      it "return correct resource" do
        resource = @base.add_resource :new_resource
        expect(resource).to be_an OneboxApiDoc::Resource
        expect(resource.name).to eq "new_resource"
      end
    end

    describe "add_version" do
      it "add version to array versions" do
        expect{ @base.add_version "1.2" }.to change(@base.versions, :size).by 1
      end
      it "does not add version to array versions if version with the same name already exist" do
        @base.add_version "1.2"
        expect{ @base.add_version "1.2" }.not_to change(@base.versions, :size)
      end
      it "return correct version" do
        version = @base.add_version '1.2'
        expect(version).to be_an OneboxApiDoc::Version
        expect(version.name).to eq "1.2"
        expect(version.is_extension?).to eq false
      end
    end

    describe "add_extension_version" do
      before do
        @base.send(:set_default_value)
      end
      it "add version to array versions" do
        expect{ @base.add_extension_version "1.2", :extension_name }.to change(@base.versions, :size).by 1
      end
      it "add extension app" do
        expect{ @base.add_extension_version "1.2", :extension_name }.to change(@base.apps, :size).by 1
      end
      it "does not add extension app if it already exist" do
        @base.add_app :extension_name
        expect{ @base.add_extension_version "1.2", :extension_name }.not_to change(@base.apps, :size)
      end
      it "does not add version to array versions if version with the same name already exist" do
        @base.add_extension_version "1.2", :extension_name
        expect{ @base.add_extension_version "1.2", :extension_name }.not_to change(@base.versions, :size)
      end
      it "return correct extension version" do
        version = @base.add_extension_version "1.2", :extension_name
        expect(version).to be_an OneboxApiDoc::Version
        expect(version.name).to eq "1.2"
        expect(version.app.name).to eq "extension_name"
        expect(version.is_extension?).to eq true
      end
    end

    describe "add_app" do
      it "add app to array apps" do
        expect{ @base.add_app :new_app }.to change(@base.apps, :size).by 1
      end
      it "does not add app to array apps if app with the same name already exist" do
        @base.add_app :new_app
        expect{ @base.add_app :new_app }.not_to change(@base.apps, :size)
      end
      it "return correct app" do
        app = @base.add_app :new_app
        expect(app).to be_an OneboxApiDoc::App
        expect(app.name).to eq "new_app"
      end
    end

    describe "add_doc" do
      before do
        @base.send(:set_default_value)
        @version = @base.default_version
      end
      it "add doc to array docs" do
        expect{ @base.add_doc @version.object_id }.to change(@base.docs, :size).by 1
      end
      it "does not add doc to array docs if doc with the same version already exist" do
        @base.add_doc @version.object_id
        expect{ @base.add_doc @version.object_id }.not_to change(@base.docs, :size)
      end
      it "return correct doc" do
        doc = @base.add_doc @version.object_id
        expect(doc).to be_an OneboxApiDoc::Doc
        expect(doc.version).to eq @version
      end
    end

    # describe "add_extension_version" do
    #   it "add extension version to @extension_versions" do
    #     base.add_extension_version :extension_name, "1.2"
    #     expect(base.extension_versions["extension_name"].size).to eq 1
    #     expect(base.extension_versions["extension_name"].map(&:version)).to include "1.2"
    #   end
    #   it "does not add extension version with duplicate name" do
    #     base.add_extension_version :extension_name, "1.2"
    #     base.add_extension_version :extension_name, "1.2"
    #     expect(base.extension_versions["extension_name"].size).to eq 1
    #     expect(base.extension_versions["extension_name"].map(&:version)).to include "1.2"
    #   end
    # end

    # describe "add_permission" do
    #   # it "add permission to @all_permissions" do
    #   #   base.add_permission :admin
    #   #   expect(base.all_permissions.size).to eq 1
    #   #   expect(base.all_permissions).to include "admin"
    #   # end
    #   # it "do not add duplicate permission to @all_permissions" do
    #   #   base.add_permission "admin"
    #   #   base.add_permission :admin
    #   #   expect(base.all_permissions.size).to eq 1
    #   #   expect(base.all_permissions).to include "admin"
    #   # end
    # end

    # describe "add_param_group" do
    #   it "add param group" do
    #     base.add_param_group :sample do
    #       puts "do something"
    #     end
    #     expect(base.param_groups.keys).to include "sample"
    #     expect(base.param_groups["sample"]).to be_a Proc
    #   end
    # end

    # describe "get_param_group" do
    #   before do
    #     @block = Proc.new { puts "do something" }
    #     base.param_groups["sample"] = @block
    #   end
    #   it "return correct proc" do
    #     param_group = base.get_param_group :sample
    #     expect(param_group).to be_a Proc
    #     expect(param_group).to eq @block
    #   end
      
    # end

  end
end