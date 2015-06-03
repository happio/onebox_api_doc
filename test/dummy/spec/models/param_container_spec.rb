require "rails_helper"

module OneboxApiDoc
  describe ParamContainer do

    class TestParamContainer < ParamContainer
      attr_reader :_params
    end

    describe "initialize" do

      it "'s block is optional" do
        @test_param = OneboxApiDoc::TestParamContainer.new
        expect(@test_param).not_to eq nil
      end

      describe "nested params" do
        it "set correct nested param" do
          @test_param = OneboxApiDoc::TestParamContainer.new do
            param :address_no, :string,
              desc: 'address number',
              permissions: [ :guest, :admin, :member ],
              required: true
            param :road, :string,
              desc: 'road',
              permissions: [ :guest, :admin, :member ],
              required: false
          end
          expect(@test_param._params).to be_an Array
          first_param = @test_param._params.first
          expect(first_param._name).to eq "address_no"
          expect(first_param._type).to eq "String"
          expect(first_param._desc).to eq "address number"
          expect(first_param._permissions).to eq [ :guest, :admin, :member ]
          expect(first_param._required).to eq true
          second_param = @test_param._params.last
          expect(second_param._name).to eq "road"
          expect(second_param._type).to eq "String"
          expect(second_param._desc).to eq "road"
          expect(second_param._permissions).to eq [ :guest, :admin, :member ]
          expect(second_param._required).to eq false
        end
      end
    end

    describe "param" do
      before do
        @test_param = OneboxApiDoc::TestParamContainer.new
      end
      it "set name to blank if not set" do
        @test_param.param(:array,
          desc: 'array of object',
          permissions: [ :guest, :admin, :member ],
          required: true) do
          param :address, :object,
            desc: 'address object',
            permissions: [ :guest, :admin, :member ],
            required: true
        end
        expect(@test_param._params.first).not_to eq nil
        expect(@test_param._params.first._name).to eq ""
        expect(@test_param._params.first._params.first).not_to eq nil
      end
      it "'s block is optional" do
        @test_param.param(:address, :object,
          desc: 'address object')
        expect(@test_param._params.first).not_to eq nil
      end
    end

    describe "validation_messages" do
      before do
        @test_param = OneboxApiDoc::TestParamContainer.new
      end
      it "return correct validation messages" do
        expect(@test_param.validation_messages({ min: -1 })).to include 'cannot be less than -1'
        expect(@test_param.validation_messages({ max: 10 })).to include 'cannot be more than 10'
        expect(@test_param.validation_messages({ within: ["online", "offline", "all"] })).to include 'must be within ["online", "offline", "all"]'
        expect(@test_param.validation_messages({ pattern: "/[A-Za-z0-9]/" })).to include 'must match format /[A-Za-z0-9]/'
        expect(@test_param.validation_messages({ email: true })).to include 'must be in email format'
        expect(@test_param.validation_messages({ min_length: 6 })).to include 'cannot have length less than 6'
        expect(@test_param.validation_messages({ max_length: 10 })).to include 'cannot have length more than 10'
      end
    end
  end
end