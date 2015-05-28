require "rails_helper"

module OneboxApiDoc
  describe Base do

    describe "reload_documentation" do
      it "error when call document class name if not load before" do
        expect{ UsersApiDoc }.to raise_error NameError
      end

      it "not error when call document class name after load" do
        OneboxApiDoc::Base.new.reload_documentation
        expect{ UsersApiDoc }.not_to raise_error
      end
      
    end
  end
end