require "rails_helper"

module OneboxApiDoc
  describe Api do

    before do
      class TestApiDoc < ApiDoc
        controller_name :users
      end
    end

    describe "initialize" do
      before do
        @api = OneboxApiDoc::Api.new(TestApiDoc, :show, "get user") do
          desc 'get current user'
          tags :mobile, :web
          permissions :member
          header do
            param :user_id, :integer, 
              desc: 'user id',
              permissions: :member,
              required: true,
              validates: {
                min: 0
              }
            param :user_auth, :string, 
              desc: 'user authentication',
              permissions: :member,
              required: true
          end
          body do
            
          end
          response do
            param :id, :integer,
              desc: 'user id',
              permissions: :member
            param :name, :string,
              desc: 'user name',
              permissions: :member
            param :email, :string,
              desc: 'user email',
              permissions: :member
          end
          error do
            code 401, "Unauthorize" do
              permissions :member
              param :code, :integer,
                desc: 'error code',
                permissions: :member
              param :message, :string,
                desc: 'error message',
                permissions: :member
            end
          end
        end
      end
      it "set correct api detail" do
        expect(@api._action).to eq "show"
        expect(@api._short_desc).to eq "get user"
        expect(@api._url).to eq "/users/:id"
        expect(@api._method).to eq "GET"
        expect(@api._desc).to eq "get current user"
        expect(@api._tags.map { |tag| tag.name }).to eq ["mobile", "web"]
        expect(@api._permissions).to eq ["member"]

        expect(@api._header).to be_a OneboxApiDoc::Api::Header
        header = @api._header
        expect(header._params).to be_an Array
        header_param1 = header._params.first
        expect(header_param1._name).to eq "user_id"
        expect(header_param1._type).to eq "Integer"
        expect(header_param1._desc).to eq "user id"
        expect(header_param1._permissions).to eq ["member"]
        expect(header_param1._required).to eq true
        expect(header_param1._default_value).to eq nil
        expect(header_param1._validates).to be_an Array
        expect(header_param1._validates).to include 'cannot be less than 0'
        expect(header_param1._warning).to eq nil
        header_param2 = header._params.last
        expect(header_param2._name).to eq "user_auth"
        expect(header_param2._type).to eq "String"
        expect(header_param2._desc).to eq "user authentication"
        expect(header_param2._permissions).to eq ["member"]
        expect(header_param2._required).to eq true
        expect(header_param2._validates).to be_an Array
        expect(header_param2._validates).to be_blank
        expect(header_param2._warning).to eq nil

        expect(@api._body).to be_a OneboxApiDoc::Api::Body
        body = @api._body
        expect(body._params).to be_blank

        expect(@api._response).to be_a OneboxApiDoc::Api::Response
        response = @api._response
        expect(response._params).to be_an Array
        response_param1 = response._params.shift
        expect(response_param1._name).to eq "id"
        expect(response_param1._type).to eq "Integer"
        expect(response_param1._desc).to eq "user id"
        expect(response_param1._permissions).to eq ["member"]

        response_param2 = response._params.shift
        expect(response_param2._name).to eq "name"
        expect(response_param2._type).to eq "String"
        expect(response_param2._desc).to eq "user name"
        expect(response_param2._permissions).to eq ["member"]

        response_param3 = response._params.shift
        expect(response_param3._name).to eq "email"
        expect(response_param3._type).to eq "String"
        expect(response_param3._desc).to eq "user email"
        expect(response_param3._permissions).to eq ["member"]

        expect(@api._error).to be_a OneboxApiDoc::Api::Error
        error = @api._error
        expect(error._codes).to be_an Array
        error_code = error._codes.first
        expect(error_code).to be_a OneboxApiDoc::Api::Error::Code
        expect(error_code._code).to eq 401
        expect(error_code._message).to eq "Unauthorize"
        expect(error_code._permissions).to eq ["member"]
        expect(error_code._params).to be_an Array
        error_param1 = error_code._params.first
        expect(error_param1).to be_a OneboxApiDoc::Param
        expect(error_param1._name).to eq "code"
        expect(error_param1._type).to eq "Integer"
        expect(error_param1._desc).to eq "error code"
        expect(error_param1._permissions).to eq ["member"]
        error_param2 = error_code._params.last
        expect(error_param2).to be_a OneboxApiDoc::Param
        expect(error_param2._name).to eq "message"
        expect(error_param2._type).to eq "String"
        expect(error_param2._desc).to eq "error message"
        expect(error_param2._permissions).to eq ["member"]
      end
    end

    describe "desc" do
      it "set correct _desc" do
        api = OneboxApiDoc::Api.new(TestApiDoc, :show, "get user")
        api.desc "api_desc"
        expect(api._desc).to eq "api_desc"
      end
    end

    describe "tags" do
      it "set correct _tags" do
        api = OneboxApiDoc::Api.new(TestApiDoc, :show, "get user")
        api.tags :tag1, :tag2, :tag3
        expect(api._tags).to be_an Array
        expected_tag_names = ["tag1", "tag2", "tag3"]
        expect(api._tags.map { |tag| tag.name }).to eq expected_tag_names
        api._tags.each do |tag|
          expect(tag.apis).to include api
        end
      end
    end

    describe "permissions" do
      it "set correct _permissions" do
        api = OneboxApiDoc::Api.new(TestApiDoc, :show, "get user")
        api.permissions :admin, :guest, :member
        expect(api._permissions).to eq ["admin", "guest", "member"]
      end
    end

    describe "header" do
      it "set correct _header" do
        api = OneboxApiDoc::Api.new(TestApiDoc, :show, "get user")
        api.header do
          param :user_id, :integer, 
            desc: 'user id',
            permissions: :member,
            required: true,
            validates: {
              min: 0
            }
        end
        expect(api._header).to be_an OneboxApiDoc::Api::Header
        header = api._header
        expect(header._params).to be_an Array
        header_param1 = header._params.first
        expect(header_param1._name).to eq "user_id"
        expect(header_param1._type).to eq "Integer"
        expect(header_param1._desc).to eq "user id"
        expect(header_param1._permissions).to eq ["member"]
        expect(header_param1._required).to eq true
        expect(header_param1._default_value).to eq nil
        expect(header_param1._validates).to be_an Array
        expect(header_param1._validates).to include 'cannot be less than 0'
        expect(header_param1._warning).to eq nil
      end
    end

    describe "body" do
      it "set correct _body" do
        api = OneboxApiDoc::Api.new(TestApiDoc, :show, "get user")
        api.body do
          param :id, :integer,
            desc: 'user id',
            permissions: :member,
            required: true,
            validates: {
              min: 0
            }
          param :email, :string,
            desc: 'user email',
            permissions: :member,
            required: true,
            validates: {
              min: 0
            }
        end
        expect(api._body).to be_an OneboxApiDoc::Api::Body
        body = api._body
        expect(body._params).to be_an Array
        body_param1 = body._params.first
        expect(body_param1._name).to eq "id"
        expect(body_param1._type).to eq "Integer"
        expect(body_param1._desc).to eq "user id"
        expect(body_param1._permissions).to eq ["member"]
        expect(body_param1._required).to eq true
        expect(body_param1._default_value).to eq nil
        expect(body_param1._validates).to be_an Array
        expect(body_param1._validates).to include 'cannot be less than 0'
        expect(body_param1._warning).to eq nil

        body_param2 = body._params.last
        expect(body_param2._name).to eq "email"
        expect(body_param2._type).to eq "String"
        expect(body_param2._desc).to eq "user email"
        expect(body_param2._permissions).to eq ["member"]
        expect(body_param2._required).to eq true
        expect(body_param2._default_value).to eq nil
        expect(body_param2._validates).to be_an Array
        expect(body_param2._validates).to include 'cannot be less than 0'
        expect(body_param2._warning).to eq nil
      end
    end

    describe "response" do
      it "set correct _response" do
        api = OneboxApiDoc::Api.new(TestApiDoc, :show, "get user")
        api.response do
          param :id, :integer,
            desc: 'user id',
            permissions: :member
          param :name, :string,
            desc: 'user name',
            permissions: :member
        end
        expect(api._response).to be_a OneboxApiDoc::Api::Response
        response = api._response
        expect(response._params).to be_an Array
        response_param1 = response._params.first
        expect(response_param1._name).to eq "id"
        expect(response_param1._type).to eq "Integer"
        expect(response_param1._desc).to eq "user id"
        expect(response_param1._permissions).to eq ["member"]

        response_param2 = response._params.last
        expect(response_param2._name).to eq "name"
        expect(response_param2._type).to eq "String"
        expect(response_param2._desc).to eq "user name"
        expect(response_param2._permissions).to eq ["member"]
      end
    end

    describe "error" do
      it "set correct _error" do
        api = OneboxApiDoc::Api.new(TestApiDoc, :show, "get user")
        api.error do
          code 401, "Unauthorize" do
            permissions :member
            param :code, :integer,
              desc: 'error code',
              permissions: :member
            param :message, :string,
              desc: 'error message',
              permissions: :member
          end
        end
        expect(api._error).to be_a OneboxApiDoc::Api::Error
        error = api._error
        expect(error._codes).to be_an Array
        error_code = error._codes.first
        expect(error_code).to be_a OneboxApiDoc::Api::Error::Code
        expect(error_code._code).to eq 401
        expect(error_code._message).to eq "Unauthorize"
        expect(error_code._permissions).to eq ["member"]
        expect(error_code._params).to be_an Array
        error_param1 = error_code._params.first
        expect(error_param1).to be_a OneboxApiDoc::Param
        expect(error_param1._name).to eq "code"
        expect(error_param1._type).to eq "Integer"
        expect(error_param1._desc).to eq "error code"
        expect(error_param1._permissions).to eq ["member"]
        error_param2 = error_code._params.last
        expect(error_param2).to be_a OneboxApiDoc::Param
        expect(error_param2._name).to eq "message"
        expect(error_param2._type).to eq "String"
        expect(error_param2._desc).to eq "error message"
        expect(error_param2._permissions).to eq ["member"]
      end
    end
  end
end