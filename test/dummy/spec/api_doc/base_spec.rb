require "rails_helper"

module OneboxApiDoc
  describe Base do

    describe "load_documentation" do
      before :each do
        @base = OneboxApiDoc::Base.new
        @base.unload_documentation
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

    describe "add_tag" do
      it "add tag to @all_tags" do
        base = OneboxApiDoc::Base.new
        base.add_tag :new_tag
        expect(base.all_tags.size).to eq 1
        expect(base.all_tags.map(&:name)).to include "new_tag"
      end
      it "do not add tag with duplicate name" do
        base = OneboxApiDoc::Base.new
        base.add_tag :new_tag
        base.add_tag :new_tag
        expect(base.all_tags.size).to eq 1
        expect(base.all_tags.map(&:name)).to include "new_tag"
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
  end
end