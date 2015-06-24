require "rails_helper"

module OneboxApiDoc
  describe Api do
    before do
      @base = OneboxApiDoc.base
      @version = @base.default_version
      @resource = @base.add_resource :product
      @doc = @base.add_doc(ApiDoc, @version.object_id, @resource.object_id)
    end

    describe "initialize" do
      # before do
      #   @api = OneboxApiDoc::Api.new(:users, :show, "get user") do
      #     desc 'get current user'
      #     tags :mobile, :web
      #     permissions :member
      #     header do
      #       param :user_id, :integer, 
      #         desc: 'user id',
      #         permissions: :member,
      #         required: true,
      #         validates: {
      #           min: 0
      #         }
      #       param :user_auth, :string, 
      #         desc: 'user authentication',
      #         permissions: :member,
      #         required: true
      #     end
      #     body do
            
      #     end
      #     response do
      #       param :id, :integer,
      #         desc: 'user id',
      #         permissions: :member
      #       param :name, :string,
      #         desc: 'user name',
      #         permissions: :member
      #       param :email, :string,
      #         desc: 'user email',
      #         permissions: :member
      #     end
      #     error do
      #       code 401, "Unauthorize" do
      #         permissions :member
      #         param :code, :integer,
      #           desc: 'error code',
      #           permissions: :member
      #         param :message, :string,
      #           desc: 'error message',
      #           permissions: :member
      #       end
      #     end
      #   end
      # end
      # it "set correct api detail" do
      #   expect(@api._action).to eq "show"
      #   expect(@api._short_desc).to eq "get user"
      #   expect(@api._url).to eq "/users/:id"
      #   expect(@api._method).to eq "GET"
      #   expect(@api._desc).to eq "get current user"
      #   expect(@api._tags.map { |tag| tag.name }).to eq ["mobile", "web"]
      #   expect(@api._permissions).to eq ["member"]

      #   expect(@api._header).to be_a OneboxApiDoc::Api::Header
      #   header = @api._header
      #   expect(header._params).to be_an Array
      #   header_param1 = header._params.first
      #   expect(header_param1._name).to eq "user_id"
      #   expect(header_param1._type).to eq "Integer"
      #   expect(header_param1._desc).to eq "user id"
      #   expect(header_param1._permissions).to eq ["member"]
      #   expect(header_param1._required).to eq true
      #   expect(header_param1._default_value).to eq nil
      #   expect(header_param1._validates).to be_an Array
      #   expect(header_param1._validates).to include 'cannot be less than 0'
      #   expect(header_param1._warning).to eq nil
      #   header_param2 = header._params.last
      #   expect(header_param2._name).to eq "user_auth"
      #   expect(header_param2._type).to eq "String"
      #   expect(header_param2._desc).to eq "user authentication"
      #   expect(header_param2._permissions).to eq ["member"]
      #   expect(header_param2._required).to eq true
      #   expect(header_param2._validates).to be_an Array
      #   expect(header_param2._validates).to be_blank
      #   expect(header_param2._warning).to eq nil

      #   expect(@api._body).to be_a OneboxApiDoc::Api::Body
      #   body = @api._body
      #   expect(body._params).to be_blank

      #   expect(@api._response).to be_a OneboxApiDoc::Api::Response
      #   response = @api._response
      #   expect(response._params).to be_an Array
      #   response_param1 = response._params.shift
      #   expect(response_param1._name).to eq "id"
      #   expect(response_param1._type).to eq "Integer"
      #   expect(response_param1._desc).to eq "user id"
      #   expect(response_param1._permissions).to eq ["member"]

      #   response_param2 = response._params.shift
      #   expect(response_param2._name).to eq "name"
      #   expect(response_param2._type).to eq "String"
      #   expect(response_param2._desc).to eq "user name"
      #   expect(response_param2._permissions).to eq ["member"]

      #   response_param3 = response._params.shift
      #   expect(response_param3._name).to eq "email"
      #   expect(response_param3._type).to eq "String"
      #   expect(response_param3._desc).to eq "user email"
      #   expect(response_param3._permissions).to eq ["member"]

      #   expect(@api._error).to be_a OneboxApiDoc::Api::Error
      #   error = @api._error
      #   expect(error._codes).to be_an Array
      #   error_code = error._codes.first
      #   expect(error_code).to be_a OneboxApiDoc::Api::Error::Code
      #   expect(error_code._code).to eq 401
      #   expect(error_code._message).to eq "Unauthorize"
      #   expect(error_code._permissions).to eq ["member"]
      #   expect(error_code._params).to be_an Array
      #   error_param1 = error_code._params.first
      #   expect(error_param1).to be_a OneboxApiDoc::Param
      #   expect(error_param1._name).to eq "code"
      #   expect(error_param1._type).to eq "Integer"
      #   expect(error_param1._desc).to eq "error code"
      #   expect(error_param1._permissions).to eq ["member"]
      #   error_param2 = error_code._params.last
      #   expect(error_param2).to be_a OneboxApiDoc::Param
      #   expect(error_param2._name).to eq "message"
      #   expect(error_param2._type).to eq "String"
      #   expect(error_param2._desc).to eq "error message"
      #   expect(error_param2._permissions).to eq ["member"]
      # end

      it "set correct id and api detail" do
        api = OneboxApiDoc::Api.new doc_id: @doc.object_id, action: :show, method: :get, 
          url: "/users/:id", short_desc: "get user profile", desc: "description",
          tag_ids: [3,5,7,9], error_ids: [5,6,7,8], permission_ids: [9,8,7,6]
        expect(api).not_to eq nil
        expect(api.doc_id).to eq @doc.object_id
        expect(api.resource_id).to eq @doc.resource_id
        expect(api.version_id).to eq @doc.version_id
        expect(api.action).to eq 'show'
        expect(api.method).to eq 'GET'
        expect(api.url).to eq "/users/:id"
        expect(api.short_desc).to eq "get user profile"
        expect(api.desc).to eq "description"
        expect(api.tag_ids).to eq [3,5,7,9]
        expect(api.error_ids).to eq [5,6,7,8]
        expect(api.permission_ids).to eq [9,8,7,6]
      end

      it "set default api request and response" do
        api = OneboxApiDoc::Api.new doc_id: @doc.object_id, action: :show, method: :get, 
          url: "/users/:id", short_desc: "get user profile"
        expect(api.request).to be_an OpenStruct
        expect(api.request.header).to be_a ParamContainer
        expect(api.request.header.params).to eq []
        expect(api.request.body).to be_a ParamContainer
        expect(api.request.body.params).to eq []
        expect(api.response).to be_a OpenStruct
        expect(api.response.header).to be_a ParamContainer
        expect(api.response.header.params).to eq []
        expect(api.response.body).to be_a ParamContainer
        expect(api.response.body.params).to eq []
      end
    end

    describe "doc" do
      before do
        @api = OneboxApiDoc::Api.new doc_id: @doc.object_id, action: :show, method: :get, 
          url: "/users/:id", short_desc: "get user profile", desc: "description",
          tag_ids: [3,5,7,9], error_ids: [5,6,7,8]
      end
      it "return correct doc" do
        doc = @api.doc
        expect(doc).to eq @doc
      end
    end

    describe "resource" do
      before do
        @api = OneboxApiDoc::Api.new doc_id: @doc.object_id, action: :show, method: :get, 
          url: "/users/:id", short_desc: "get user profile", desc: "description",
          tag_ids: [3,5,7,9], error_ids: [5,6,7,8]
      end
      it "return correct resource" do
        resource = @api.resource
        expect(resource).to eq @resource
      end
    end

    describe "version" do
      before do
        @api = OneboxApiDoc::Api.new doc_id: @doc.object_id, action: :show, method: :get, 
          url: "/users/:id", short_desc: "get user profile", desc: "description",
          tag_ids: [3,5,7,9], error_ids: [5,6,7,8]
      end
      it "return correct version" do
        version = @api.version
        expect(version).to eq @version
      end
    end

    describe "tags" do
      before do
        @tags = []
        @tags << @doc.add_tag(:tag1)
        @tags << @doc.add_tag(:tag2)
        @tags << @doc.add_tag(:tag3)
        @api = OneboxApiDoc::Api.new doc_id: @doc.object_id, action: :show, method: :get, 
          url: "/users/:id", short_desc: "get user profile", desc: "description",
          tag_ids: @tags.map(&:object_id), error_ids: [5,6,7,8]
      end
      it "return correct tags" do
        tags = @api.tags
        expect(tags).to be_an Array
        expect(tags.size).to be > 0 and eq @tags.size
        tags.each do |tag|
          expect(tag).to be_an OneboxApiDoc::Tag
        end
        expect(tags).to eq @tags
      end
    end

    describe "permissions" do
      before do
        @permissions = []
        @permissions << @doc.add_permission(:permission1)
        @permissions << @doc.add_permission(:permission2)
        @permissions << @doc.add_permission(:permission3)
        @api = OneboxApiDoc::Api.new doc_id: @doc.object_id, action: :show, method: :get, 
          url: "/users/:id", short_desc: "get user profile", desc: "description",
          tag_ids: [3,5,7,9], error_ids: [5,6,7,8], permission_ids: @permissions.map(&:object_id)
      end
      it "return correct permissions" do
        permissions = @api.permissions
        expect(permissions).to be_an Array
        expect(permissions.size).to be > 0 and eq @permissions.size
        permissions.each do |permission|
          expect(permission).to be_an OneboxApiDoc::Permission
        end
        expect(permissions).to eq @permissions
      end
    end

    describe "errors" do
      before do
        @api = OneboxApiDoc::Api.new doc_id: @doc.object_id, action: :show, method: :get, 
          url: "/users/:id", short_desc: "get user profile", desc: "description",
          tag_ids: [3,5,7,9], permission_ids: [5,6,7,8]
        @errors = []
        @errors << @doc.add_error(@api, 401, 'Not Found')
        @errors << @doc.add_error(@api, 400, 'Bad Request')
      end
      it "return correct errors" do
        errors = @api.errors
        expect(errors).to be_an Array
        expect(errors.size).to be > 0 and eq @errors.size
        errors.each do |error|
          expect(error).to be_an OneboxApiDoc::Error
        end
        expect(errors).to eq @errors
      end
    end

    describe "is_extension?" do
      it "return true if its version is extension version" do
        @version = @base.default_version
        @resource = @base.add_resource :product
        @doc = @base.add_doc(ApiDoc, @version.object_id, @resource.object_id)
        @api = OneboxApiDoc::Api.new doc_id: @doc.object_id, action: :show
        expect(@api.is_extension?).to eq false
      end
      it "return false if its version is main version" do
        @version = @base.add_extension_version '0.3', :extension_name
        @resource = @base.add_resource :product
        @doc = @base.add_doc(ApiDoc, @version.object_id, @resource.object_id)
        @api = OneboxApiDoc::Api.new doc_id: @doc.object_id, action: :show
        expect(@api.is_extension?).to eq true
      end
    end

    # describe "desc" do
    #   it "set correct _desc" do
    #     api = OneboxApiDoc::Api.new(:users, :show, "get user")
    #     api.desc "api_desc"
    #     expect(api._desc).to eq "api_desc"
    #   end
    # end

    # describe "tags" do
    #   it "set correct _tags" do
    #     api = OneboxApiDoc::Api.new(:users, :show, "get user")
    #     api.tags :tag1, :tag2, :tag3
    #     expect(api._tags).to be_an Array
    #     expected_tag_names = ["tag1", "tag2", "tag3"]
    #     expect(api._tags.map { |tag| tag.name }).to eq expected_tag_names
    #     api._tags.each do |tag|
    #       expect(tag.apis).to include api
    #     end
    #   end
    # end

    # describe "permissions" do
    #   it "set correct _permissions" do
    #     api = OneboxApiDoc::Api.new(:users, :show, "get user")
    #     api.permissions :admin, :guest, :member
    #     expect(api._permissions).to eq ["admin", "guest", "member"]
    #   end
    # end

    # describe "header" do
    #   it "set correct _header" do
    #     api = OneboxApiDoc::Api.new(:users, :show, "get user")
    #     api.header do
    #       param :user_id, :integer, 
    #         desc: 'user id',
    #         permissions: :member,
    #         required: true,
    #         validates: {
    #           min: 0
    #         }
    #     end
    #     expect(api._header).to be_an OneboxApiDoc::Api::Header
    #     header = api._header
    #     expect(header._params).to be_an Array
    #     header_param1 = header._params.first
    #     expect(header_param1._name).to eq "user_id"
    #     expect(header_param1._type).to eq "Integer"
    #     expect(header_param1._desc).to eq "user id"
    #     expect(header_param1._permissions).to eq ["member"]
    #     expect(header_param1._required).to eq true
    #     expect(header_param1._default_value).to eq nil
    #     expect(header_param1._validates).to be_an Array
    #     expect(header_param1._validates).to include 'cannot be less than 0'
    #     expect(header_param1._warning).to eq nil
    #   end
    # end

    # describe "body" do
    #   it "set correct _body" do
    #     api = OneboxApiDoc::Api.new(:users, :show, "get user")
    #     api.body do
    #       param :id, :integer,
    #         desc: 'user id',
    #         permissions: :member,
    #         required: true,
    #         validates: {
    #           min: 0
    #         }
    #       param :email, :string,
    #         desc: 'user email',
    #         permissions: :member,
    #         required: true,
    #         validates: {
    #           min: 0
    #         }
    #     end
    #     expect(api._body).to be_an OneboxApiDoc::Api::Body
    #     body = api._body
    #     expect(body._params).to be_an Array
    #     body_param1 = body._params.first
    #     expect(body_param1._name).to eq "id"
    #     expect(body_param1._type).to eq "Integer"
    #     expect(body_param1._desc).to eq "user id"
    #     expect(body_param1._permissions).to eq ["member"]
    #     expect(body_param1._required).to eq true
    #     expect(body_param1._default_value).to eq nil
    #     expect(body_param1._validates).to be_an Array
    #     expect(body_param1._validates).to include 'cannot be less than 0'
    #     expect(body_param1._warning).to eq nil

    #     body_param2 = body._params.last
    #     expect(body_param2._name).to eq "email"
    #     expect(body_param2._type).to eq "String"
    #     expect(body_param2._desc).to eq "user email"
    #     expect(body_param2._permissions).to eq ["member"]
    #     expect(body_param2._required).to eq true
    #     expect(body_param2._default_value).to eq nil
    #     expect(body_param2._validates).to be_an Array
    #     expect(body_param2._validates).to include 'cannot be less than 0'
    #     expect(body_param2._warning).to eq nil
    #   end
    # end

    # describe "response" do
    #   it "set correct _response" do
    #     api = OneboxApiDoc::Api.new(:users, :show, "get user")
    #     api.response do
    #       param :id, :integer,
    #         desc: 'user id',
    #         permissions: :member
    #       param :name, :string,
    #         desc: 'user name',
    #         permissions: :member
    #     end
    #     expect(api._response).to be_a OneboxApiDoc::Api::Response
    #     response = api._response
    #     expect(response._params).to be_an Array
    #     response_param1 = response._params.first
    #     expect(response_param1._name).to eq "id"
    #     expect(response_param1._type).to eq "Integer"
    #     expect(response_param1._desc).to eq "user id"
    #     expect(response_param1._permissions).to eq ["member"]

    #     response_param2 = response._params.last
    #     expect(response_param2._name).to eq "name"
    #     expect(response_param2._type).to eq "String"
    #     expect(response_param2._desc).to eq "user name"
    #     expect(response_param2._permissions).to eq ["member"]
    #   end
    # end

    # describe "error" do
    #   it "set correct _error" do
    #     api = OneboxApiDoc::Api.new(:users, :show, "get user")
    #     api.error do
    #       code 401, "Unauthorize" do
    #         permissions :member
    #         param :code, :integer,
    #           desc: 'error code',
    #           permissions: :member
    #         param :message, :string,
    #           desc: 'error message',
    #           permissions: :member
    #       end
    #     end
    #     expect(api._error).to be_a OneboxApiDoc::Api::Error
    #     error = api._error
    #     expect(error._codes).to be_an Array
    #     error_code = error._codes.first
    #     expect(error_code).to be_a OneboxApiDoc::Api::Error::Code
    #     expect(error_code._code).to eq 401
    #     expect(error_code._message).to eq "Unauthorize"
    #     expect(error_code._permissions).to eq ["member"]
    #     expect(error_code._params).to be_an Array
    #     error_param1 = error_code._params.first
    #     expect(error_param1).to be_a OneboxApiDoc::Param
    #     expect(error_param1._name).to eq "code"
    #     expect(error_param1._type).to eq "Integer"
    #     expect(error_param1._desc).to eq "error code"
    #     expect(error_param1._permissions).to eq ["member"]
    #     error_param2 = error_code._params.last
    #     expect(error_param2).to be_a OneboxApiDoc::Param
    #     expect(error_param2._name).to eq "message"
    #     expect(error_param2._type).to eq "String"
    #     expect(error_param2._desc).to eq "error message"
    #     expect(error_param2._permissions).to eq ["member"]
    #   end
    # end

    # describe Api::Error do
    #   let(:error) { OneboxApiDoc::Api::Error.new }

    #   describe "initialize" do
    #     it "set default value to @_codes" do
    #       expect(error._codes).to eq []
    #     end
    #   end

    #   describe "code" do
    #     it "add error code to @_codes" do
    #       error.code(404, "Not Found")
    #       expect(error._codes.size).to eq 1
    #       expect(error._codes.first).to be_a OneboxApiDoc::Api::Error::Code
    #       expect(error._codes.first._code).to eq 404
    #       expect(error._codes.first._message).to eq "Not Found"
    #     end
    #   end

    #   describe Api::Error::Code do
    #     let(:code) { OneboxApiDoc::Api::Error::Code.new(404, "Not Found") }

    #     describe "initialize" do
    #       it "set correct code, message and set default value for params and permissions" do
    #         expect(code._code).to eq 404
    #         expect(code._message).to eq "Not Found"
    #         expect(code._params).to eq []
    #         expect(code._permissions).to eq []
    #       end
    #     end

    #     describe "permissions" do
    #       it "add permission to _permissions" do
    #         code.permissions :admin, :member
    #         expect(code._permissions.size).to eq 2
    #         expect(code._permissions).to include "admin"
    #         expect(code._permissions).to include "member"
    #       end
    #     end

    #     describe "param" do
    #       it "add param to _params" do
    #         code.param :error_message, :string,
    #           desc: 'error message',
    #           permissions: :admin
    #         expect(code._params.size).to eq 1
    #         expect(code._params.first).to be_a OneboxApiDoc::Param
    #         expect(code._params.first._name).to eq "error_message"
    #         expect(code._params.first._type).to eq "String"
    #         expect(code._params.first._desc).to eq "error message"
    #         expect(code._params.first._permissions).to eq ["admin"]
    #       end
    #     end
    #   end
    # end
  end
end