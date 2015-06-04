require "rails_helper"

module OneboxApiDoc
  describe Base do

    describe "load_documentation" do
      before :each do
        OneboxApiDoc::Base.new.unload_documentation
      end

      it "load document class" do
        OneboxApiDoc::Base.new.load_documentation
        expect{ UsersApiDoc }.not_to raise_error
      end
    end

    describe "unload_documentation" do
      it "does not load document class if the class wasn't load yet" do
        OneboxApiDoc::Base.new.unload_documentation
        expect{ UsersApiDoc }.to raise_error
      end
      it "unload document class if the class was loaded" do
        OneboxApiDoc::Base.new.load_documentation
        OneboxApiDoc::Base.new.unload_documentation
        expect{ UsersApiDoc }.to raise_error
      end
    end

    describe "api_docs_paths" do
      it "return correct array of document paths" do
        expect(OneboxApiDoc::Base.new.api_docs_paths).to eq Dir.glob(Rails.root.join(*OneboxApiDoc::Engine.api_docs_matcher.split("/")))
      end
    end

    describe "class methods" do
      describe "api_docs" do
        it "return all api doc classes" do
          expected_api_docs = OneboxApiDoc::ApiDoc.subclasses
          expect(OneboxApiDoc::Base.api_docs).to eq expected_api_docs
        end
      end
      describe "add_new_tag" do
        it "add tag to @all_tags" do
          tag = OneboxApiDoc::Tag.find_or_initialize "new tag"
          OneboxApiDoc::Base.add_new_tag tag
          expect(OneboxApiDoc::Base.all_tags).to include tag
        end
      end
    end
  end
end