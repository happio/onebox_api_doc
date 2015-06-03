require "rails_helper"

module OneboxApiDoc
  describe ApiDoc do

    class TestApiDoc < ApiDoc
      controller_name :products
      version "1.2.3"

      api :show, 'short_desc' do
        desc 'description'
        tags :mobile, :web
        permissions :guest, :admin, :member
        header do
          param :header_param1, :string, 
            desc: 'header_param1 desc',
            permissions: [ :guest, :admin, :member ],
            required: true,
            default: 'header_param1 default',
            validates: {
              min: -1,
              max: 10,
              within: ["a", "b"],
              pattern: "header_param1 pattern",
              email: true,
              min_length: 6,
              max_length: 10
            },
            warning: "header_param1 warning" do
              param :header_param1_1, :integer, 
                desc: 'header_param1_1 desc',
                permissions: [ :guest, :member ],
                required: false,
                default: 'header_param1_1 default',
                validates: {
                  min: 5,
                  max: 15,
                  within: ["c", "d", "e"],
                  pattern: "header_param1_1 pattern",
                  email: false,
                  min_length: 4,
                  max_length: 6
                } do
                  # param
                  ;
                end
            end
        end
        body do
          param :body_param_1, :string, 
            desc: 'body_param_1 desc',
            permissions: [ :guest, :admin, :member ],
            required: true,
            default: 'body_param_1 default',
            validates: {
              min: -1,
              max: 10,
              within: [:a, :b],
              pattern: "",
              email: true
            },
            warning: "body_param_1 warning" do
              # param
              ;
            end
        end
        response do
          param :response_param_1, :string, 
            desc: 'response_param_1 desc',
            permissions: [ :guest, :admin, :member ],
            validates: {
              min: -1,
              max: 10,
              within: [:a, :b],
              pattern: "",
              email: true
            },
            warning: "response_param_1 warning" do
              # param
              ;
            end
        end
        error do
          code 404, "" do
            permissions [:guest, :admin, :member]
            param :error_code_param_1, :string, 
              desc: '',
              permissions: [ :guest, :admin, :member ] do
                ;
              end
          end
        end
      end
    end

    it "set controller name and version to doc" do
      expect(TestApiDoc._controller_name).to eq "products"
    end

    it "set version to doc" do
      expect(TestApiDoc._version).to eq "1.2.3"
    end

    it "set correct api detail" do
      expect(TestApiDoc._apis).not_to be_blank
      api = TestApiDoc._apis.first
      expect(api._action).to eq "show"
      expect(api._short_desc).to eq "short_desc"
      expect(api._url).to eq "/products/:id"
      expect(api._method).to eq "GET"
      expect(api._desc).to eq "description"
      expect(api._tags.map { |tag| tag.name }).to eq ["mobile", "web"]
      expect(api._permissions).to eq [:guest, :admin, :member]

      expect(api._header).to be_a OneboxApiDoc::Api::Header
      header = api._header
      expect(header._params).to be_an Array
      header_param1 = header._params.first
      expect(header_param1._name).to eq "header_param1"
      expect(header_param1._type).to eq "String"
      expect(header_param1._desc).to eq "header_param1 desc"
      expect(header_param1._permissions).to eq [ :guest, :admin, :member ]
      expect(header_param1._required).to eq true
      expect(header_param1._default_value).to eq "header_param1 default"
      expect(header_param1._validates).to be_an Array
      expect(header_param1._validates).to include 'cannot be less than -1'
      expect(header_param1._validates).to include 'cannot be more than 10'
      expect(header_param1._validates).to include 'must be within ["a", "b"]'
      expect(header_param1._validates).to include 'must match format header_param1 pattern'
      expect(header_param1._validates).to include 'must be in email format'
      expect(header_param1._validates).to include 'cannot have length less than 6'
      expect(header_param1._validates).to include 'cannot have length more than 10'
      expect(header_param1._warning).to eq "header_param1 warning"
      expect(header_param1._params).to be_an Array
      header_param1_1 = header_param1._params.first
      expect(header_param1_1._name).to eq "header_param1_1"
      expect(header_param1_1._type).to eq "Integer"
      expect(header_param1_1._desc).to eq "header_param1_1 desc"
      expect(header_param1_1._permissions).to eq [ :guest, :member ]
      expect(header_param1_1._required).to eq false
      expect(header_param1_1._default_value).to eq "header_param1_1 default"
      expect(header_param1_1._validates).to be_an Array
      expect(header_param1_1._validates).to include 'cannot be less than 5'
      expect(header_param1_1._validates).to include 'cannot be more than 15'
      expect(header_param1_1._validates).to include 'must be within ["c", "d", "e"]'
      expect(header_param1_1._validates).to include 'must match format header_param1_1 pattern'
      expect(header_param1_1._validates).not_to include 'must be in email format'
      expect(header_param1_1._validates).to include 'cannot have length less than 4'
      expect(header_param1_1._validates).to include 'cannot have length more than 6'
      expect(header_param1_1._warning).to eq nil
      expect(header_param1_1._params).to be_an Array

      expect(api._body).to be_a OneboxApiDoc::Api::Body
      expect(api._response).to be_a OneboxApiDoc::Api::Response
      expect(api._error).to be_a OneboxApiDoc::Api::Error
    end

  end
end