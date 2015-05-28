require "rails_helper"

module OneboxApiDoc
  describe Base do

    describe "reload_documentation" do
      before :each do
        OneboxApiDoc::Base.new.unload_documentation
      end

      it "load document class" do
        OneboxApiDoc::Base.new.reload_documentation
        expect{ UsersApiDoc }.not_to raise_error
      end
    end

    describe "unload_documentation" do
      it "does not load document class if the class wasn't load yet" do
        OneboxApiDoc::Base.new.unload_documentation
        expect{ UsersApiDoc }.to raise_error
      end
      it "unload document class if the class was loaded" do
        OneboxApiDoc::Base.new.reload_documentation
        OneboxApiDoc::Base.new.unload_documentation
        expect{ UsersApiDoc }.to raise_error
      end
    end

    describe "api_docs_paths" do
      it "return correct array of document paths" do
        expect(OneboxApiDoc::Base.new.api_docs_paths).to eq Dir.glob(Rails.root.join(*OneboxApiDoc::Engine.api_docs_matcher.split("/")))
      end
    end
  end
end