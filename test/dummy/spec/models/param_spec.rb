require "rails_helper"

module OneboxApiDoc
  describe Param do

    describe "initialize" do
      it "set correct param name and type" do
        @param = OneboxApiDoc::Param.new :status, :string
        expect(@param._name).to eq "status"
        expect(@param._type).to eq "String"
      end

      it "'s name is optional" do
        @param = OneboxApiDoc::Param.new '', :integer
        expect(@param).not_to eq nil
        expect(@param._name).to eq ""
      end

      it "'s type is require" do
        expect{ @param = OneboxApiDoc::Param.new :status }.to raise_error
      end

      it "set correct param options" do
        @param = OneboxApiDoc::Param.new :status, :string, 
          desc: 'status',
          permissions: [ :guest, :admin, :member ],
          required: false,
          default: 'all'
        expect(@param).not_to eq nil
        expect(@param._permissions).to eq [ "guest", "admin", "member" ]
        expect(@param._required).to eq false
        expect(@param._default_value).to eq 'all'
      end

      it "'s others option is optional" do
        @param = OneboxApiDoc::Param.new :address, :object do
          param :address, :string,
            desc: 'address',
            permissions: [ :guest, :admin, :member ],
            required: true
        end
        expect(@param).not_to eq nil
      end

      it "'s block is optional" do
        @param = OneboxApiDoc::Param.new :address, :object, 
          desc: 'address object',
          permissions: [ :guest, :admin, :member ],
          required: true
        expect(@param).not_to eq nil
      end

      describe "validations" do
        it "set correct validation message" do
          @param = OneboxApiDoc::Param.new :status, :string, validates: { min: -1 }
          expect(@param._validates).to include 'cannot be less than -1'

          @param = OneboxApiDoc::Param.new :status, :string, validates: { max: 10 }
          expect(@param._validates).to include 'cannot be more than 10'

          @param = OneboxApiDoc::Param.new :status, :string, validates: { within: ["online", "offline", "all"] }
          expect(@param._validates).to include 'must be within ["online", "offline", "all"]'

          @param = OneboxApiDoc::Param.new :status, :string, validates: { pattern: "/[A-Za-z0-9]/" }
          expect(@param._validates).to include 'must match format /[A-Za-z0-9]/'

          @param = OneboxApiDoc::Param.new :status, :string, validates: { email: true }
          expect(@param._validates).to include 'must be in email format'

          @param = OneboxApiDoc::Param.new :status, :string, validates: { min_length: 6 }
          expect(@param._validates).to include 'cannot have length less than 6'

          @param = OneboxApiDoc::Param.new :status, :string, validates: { max_length: 10 }
          expect(@param._validates).to include 'cannot have length more than 10'
        end
      end

      describe "nested params" do
        it "set correct nested param" do
          @param = OneboxApiDoc::Param.new :address, :object, 
          desc: 'address object',
          permissions: [ :guest, :admin, :member ],
          required: true do
            param :address_no, :string,
              desc: 'address number',
              permissions: [ :guest, :admin, :member ],
              required: true
            param :road, :string,
              desc: 'road',
              permissions: [ :guest, :admin, :member ],
              required: false
          end
          expect(@param._params).to be_an Array
          first_param = @param._params.first
          expect(first_param._name).to eq "address_no"
          expect(first_param._type).to eq "String"
          expect(first_param._desc).to eq "address number"
          expect(first_param._permissions).to eq [ "guest", "admin", "member" ]
          expect(first_param._required).to eq true
          second_param = @param._params.last
          expect(second_param._name).to eq "road"
          expect(second_param._type).to eq "String"
          expect(second_param._desc).to eq "road"
          expect(second_param._permissions).to eq [ "guest", "admin", "member" ]
          expect(second_param._required).to eq false
        end
      end
    end
  end
end