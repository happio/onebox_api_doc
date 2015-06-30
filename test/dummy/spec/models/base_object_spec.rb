require "rails_helper"

module OneboxApiDoc
  describe BaseObject do
    
    describe "initialize" do
      before do
        class SampleObject < BaseObject
          attr_accessor :name, :reference_ids
        end
      end

      it "set attribute values" do
        sample = OneboxApiDoc::SampleObject.new(name: "sample", reference_ids: [1,2,3,4])
        expect(sample.name).to eq "sample"
        expect(sample.reference_ids).to eq [1,2,3,4]
      end

      it "convert symbol attribute values to string" do
        sample = OneboxApiDoc::SampleObject.new(name: :sample, reference_ids: [1,2,3,4])
        expect(sample.name).to eq "sample"
        expect(sample.reference_ids).to eq [1,2,3,4]
      end

      it "set default value" do
        expect_any_instance_of(OneboxApiDoc::SampleObject).to receive :set_default_value
        OneboxApiDoc::SampleObject.new name: "name"
      end
    end

  end
end