require "rails_helper"

module OneboxApiDoc
  describe ApiDoc do

    describe "overall" do
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
        expect(TestApiDoc._version).to be_a OneboxApiDoc::Version
        expect(TestApiDoc._version.version).to eq "1.2.3"
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
        expect(api._permissions).to eq ["guest", "admin", "member"]

        expect(api._header).to be_a OneboxApiDoc::Api::Header
        header = api._header
        expect(header._params).to be_an Array
        header_param1 = header._params.first
        expect(header_param1._name).to eq "header_param1"
        expect(header_param1._type).to eq "String"
        expect(header_param1._desc).to eq "header_param1 desc"
        expect(header_param1._permissions).to eq ["guest", "admin", "member"]
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
        expect(header_param1_1._permissions).to eq [ "guest", "member" ]
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

    describe "controller_name" do
      class ControllerNameApiDoc < ApiDoc
        controller_name :test_controller_names
      end
      it "set correct controller name" do
        expect(ControllerNameApiDoc._controller_name).to eq "test_controller_names"
      end

      class WithoutControllerNameApiDoc < ApiDoc
      end
      it "set controller name according to class name if not calling" do
        expect(WithoutControllerNameApiDoc._controller_name).to eq "without_controller_names"
      end
    end

    describe "version" do
      class VersionApiDoc < ApiDoc
        version "0.0.1"
      end
      it "set correct version" do
        expect(VersionApiDoc._version).to be_a OneboxApiDoc::Version
        expect(VersionApiDoc._version.version).to eq "0.0.1"
      end

      class WithoutVersionApiDoc < ApiDoc
      end
      it "set version to default version" do
        expect(WithoutVersionApiDoc._version).to be_a OneboxApiDoc::Version
        expect(WithoutVersionApiDoc._version).to eq OneboxApiDoc.base.default_version
      end

      it "set correct core versions if it is extension api doc"
    end

    describe "api" do
      before do
        @base = OneboxApiDoc.base
      end

      class ApiApiDoc < ApiDoc
        controller_name :products
        api :show, 'short_desc' do
          desc 'description'
          tags :mobile, :web
          permissions :guest, :admin, :member
          header do
          end
          body do
          end
          response do
          end
          error do
          end
        end
        api :update, 'short_desc' do
          desc 'description'
          tags :mobile, :web
          permissions :guest, :admin, :member
          header do
          end
          body do
          end
          response do
          end
          error do
          end
        end
      end
      it "set correct apis" do
        api = ApiApiDoc._apis
        expect(api).to be_an Array
        expect(api.size).to eq 2
        api1 = api.first
        expect(api1._action).to eq "show"
        expect(api1._short_desc).to eq "short_desc"
        expect(api1._url).to eq "/products/:id"
        expect(api1._method).to eq "GET"
        expect(api1._desc).to eq "description"
        expect(api1._tags.map { |tag| tag.name }).to eq ["mobile", "web"]
        expect(api1._permissions).to eq ["guest", "admin", "member"]
        api2 = api.last
        expect(api2._action).to eq "update"
        expect(api2._short_desc).to eq "short_desc"
        expect(api2._url).to eq "/products/:id"
        expect(api2._method).to eq "PATCH"
        expect(api2._desc).to eq "description"
        expect(api2._tags.map { |tag| tag.name }).to eq ["mobile", "web"]
        expect(api2._permissions).to eq ["guest", "admin", "member"]
      end
      it "add api to base apis" do
        apis = ApiApiDoc._apis
        apis.each do |api|
          expect(@base.all_apis).to include api
        end
      end
      it "add api to version" do
        apis = ApiApiDoc._apis
        apis.each do |api|
          expect(ApiApiDoc._version.apis).to include api
        end
      end
    end

    describe "def_param_group" do
      class DefParamGroupApiDoc < ApiDoc
        def_param_group :user_header do
          param :user_id, :string, 
            desc: 'user id',
            permissions: :member,
            required: true
          param :user_type, :string, 
            desc: 'user type',
            permissions: :member,
            required: true
          param :user_auth, :string, 
            desc: 'user authentication',
            permissions: :member,
            required: true
        end
      end
      it "add param group to base" do
        expect(OneboxApiDoc.base.param_groups).to be_an Hash
        expect(OneboxApiDoc.base.param_groups.keys).to include "user_header"
      end
    end

    describe "param_group" do
      before do
        OneboxApiDoc.base.add_param_group :user_header do
          param :user_id, :string, 
            desc: 'user id',
            permissions: :member,
            required: true
          param :user_type, :string, 
            desc: 'user type',
            permissions: :member,
            required: true
          param :user_auth, :string, 
            desc: 'user authentication',
            permissions: :member,
            required: true
        end

        class ParamGroupApiDoc < ApiDoc
          controller_name :users
          api :show, 'short_desc' do
            desc 'description'
            tags :mobile, :web
            permissions :guest, :admin, :member
            header do
              param_group :user_header
            end
            body do
            end
            response do
            end
            error do
            end
          end
          api :update, 'short_desc' do
            desc 'description'
            tags :mobile, :web
            permissions :guest, :admin, :member
            header do
              param_group :user_header
            end
            body do
            end
            response do
            end
            error do
            end
          end
        end
      end

      it "add param group to base" do
        api = ParamGroupApiDoc._apis
        expect(api).to be_an Array
        expect(api.size).to eq 2
        api1 = api.first
        expect(api1._action).to eq "show"
        expect(api1._short_desc).to eq "short_desc"
        expect(api1._url).to eq "/users/:id"
        expect(api1._method).to eq "GET"
        expect(api1._desc).to eq "description"
        expect(api1._tags.map { |tag| tag.name }).to eq ["mobile", "web"]
        expect(api1._permissions).to eq ["guest", "admin", "member"]
        api1_header_params = api1._header._params
        expect(api1_header_params).to be_an Array
        expect(api1_header_params.size).to eq 3
        api1_header_params1 = api1_header_params.shift
        expect(api1_header_params1._name).to eq "user_id"
        expect(api1_header_params1._type).to eq "String"
        expect(api1_header_params1._desc).to eq "user id"
        expect(api1_header_params1._permissions).to eq ["member"]
        expect(api1_header_params1._required).to eq true
        api1_header_params2 = api1_header_params.shift
        expect(api1_header_params2._name).to eq "user_type"
        expect(api1_header_params2._type).to eq "String"
        expect(api1_header_params2._desc).to eq "user type"
        expect(api1_header_params2._permissions).to eq ["member"]
        expect(api1_header_params2._required).to eq true
        api1_header_params3 = api1_header_params.shift
        expect(api1_header_params3._name).to eq "user_auth"
        expect(api1_header_params3._type).to eq "String"
        expect(api1_header_params3._desc).to eq "user authentication"
        expect(api1_header_params3._permissions).to eq ["member"]
        expect(api1_header_params3._required).to eq true

        api2 = api.last
        expect(api2._action).to eq "update"
        expect(api2._short_desc).to eq "short_desc"
        expect(api2._url).to eq "/users/:id"
        expect(api2._method).to eq "PATCH"
        expect(api2._desc).to eq "description"
        expect(api2._tags.map { |tag| tag.name }).to eq ["mobile", "web"]
        expect(api2._permissions).to eq ["guest", "admin", "member"]
        api2_header_params = api2._header._params
        expect(api2_header_params).to be_an Array
        expect(api2_header_params.size).to eq 3
        api2_header_params1 = api2_header_params.shift
        expect(api2_header_params1._name).to eq "user_id"
        expect(api2_header_params1._type).to eq "String"
        expect(api2_header_params1._desc).to eq "user id"
        expect(api2_header_params1._permissions).to eq ["member"]
        expect(api2_header_params1._required).to eq true
        api2_header_params2 = api2_header_params.shift
        expect(api2_header_params2._name).to eq "user_type"
        expect(api2_header_params2._type).to eq "String"
        expect(api2_header_params2._desc).to eq "user type"
        expect(api2_header_params2._permissions).to eq ["member"]
        expect(api2_header_params2._required).to eq true
        api2_header_params3 = api2_header_params.shift
        expect(api2_header_params3._name).to eq "user_auth"
        expect(api2_header_params3._type).to eq "String"
        expect(api2_header_params3._desc).to eq "user authentication"
        expect(api2_header_params3._permissions).to eq ["member"]
        expect(api2_header_params3._required).to eq true
      end
    end

  end
end