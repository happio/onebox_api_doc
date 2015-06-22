require "rails_helper"

module OneboxApiDoc
  describe BaseObject do
    
    describe "initialize" do
      before do
        class SampleObject < BaseObject
          attr_accessor :name
        end
      end

      it "set attribute values" do
        sample = OneboxApiDoc::SampleObject.new(name: "sample")
        expect(sample.name).to eq "sample"
      end

      it "set default value" do
        expect_any_instance_of(OneboxApiDoc::SampleObject).to receive :set_default_value
        OneboxApiDoc::SampleObject.new name: "name"
      end
    end

  end
end