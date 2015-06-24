require "rails_helper"

module OneboxApiDoc
  describe ApiDoc do

    before do
      @base = OneboxApiDoc.base
    end

    describe "overall" do
      before do
        class TestApiDoc < ApiDoc
          controller_name :products
          version "1.2.3"

          api :show, 'product detail' do
            desc 'get product detail'
            tags :mobile, :web
            permissions :guest, :admin, :member
            request do
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
                        param :header_param1_1_1, :integer, 
                          desc: 'header_param1_1_1 desc',
                          permissions: [ :guest, :member ],
                          required: false,
                          default: 'header_param1_1_1 default',
                          validates: {
                            min: 5,
                            max: 15,
                            within: ["c", "d", "e"],
                            pattern: "header_param1_1_1 pattern",
                            email: false,
                            min_length: 4,
                            max_length: 6
                          }
                      end
                  end
              end
              body do
                param :body_param1, :string, 
                  desc: 'body_param1 desc',
                  permissions: [ :guest, :admin, :member ],
                  required: true,
                  default: 'body_param1 default',
                  validates: {
                    min: -1,
                    max: 10,
                    within: [:a, :b],
                    pattern: "body_param1 pattern",
                    email: true
                  },
                  warning: "body_param1 warning"
              end
            end
            
            response do
              header do
                param :resheader_param1, :string, 
                  desc: 'resheader_param1 desc',
                  permissions: [ :guest, :admin, :member ],
                  warning: "resheader_param1 warning"
              end
              body do
                param :resbody_param1, :string, 
                  desc: 'resbody_param1 desc',
                  permissions: [ :guest, :admin, :member ],
                  warning: "resbody_param1 warning"
              end
            end
            error do
              code 404, "Not Found" do
                permissions :guest, :admin, :member
                param :error_message, :string, 
                  desc: 'error message',
                  permissions: [ :guest, :admin, :member ]
              end
            end
          end
        end
        @doc = @base.docs.detect { |doc| doc.class == TestApiDoc }
      end

      it "set controller name and version to doc" do
        expect(@doc.resource).to be_an OneboxApiDoc::Resource
        expect(@doc.resource.name).to eq "products"
      end

      it "set version to doc" do
        expect(@doc.version).to be_an OneboxApiDoc::Version
        expect(@doc.version.name).to eq "1.2.3"
      end

      it "set correct api detail" do
        expect(@doc.apis).not_to be_blank
        api = @doc.apis.first
        expect(api.action).to eq "show"
        expect(api.short_desc).to eq "product detail"
        expect(api.url).to eq "/products/:id"
        expect(api.method).to eq "GET"
        expect(api.desc).to eq "get product detail"
        expect(api.tags.map(&:name)).to eq ["mobile", "web"]
        expect(api.permissions.map(&:name)).to eq ["guest", "admin", "member"]

        # request
        expect(api.request).to be_a OpenStruct
        request_header = api.request.header
        expect(request_header).to be_a ParamContainer
        expect(request_header.params).to be_an Array
        expect(request_header.params.size).to eq 1
        request_body = api.request.body
        expect(request_body).to be_a ParamContainer
        expect(request_body.params).to be_an Array
        expect(request_body.params.size).to eq 1

        reqheader_param1 = request_header.params.first
        expect(reqheader_param1.name).to eq "header_param1"
        expect(reqheader_param1.type).to eq "String"
        expect(reqheader_param1.desc).to eq "header_param1 desc"
        expect(reqheader_param1.permissions.map(&:name)).to eq ["guest", "admin", "member"]
        expect(reqheader_param1.required).to eq true
        expect(reqheader_param1.default).to eq "header_param1 default"
        expect(reqheader_param1.validates).to be_an Array
        expect(reqheader_param1.validates).to include 'cannot be less than -1'
        expect(reqheader_param1.validates).to include 'cannot be more than 10'
        expect(reqheader_param1.validates).to include 'must be within ["a", "b"]'
        expect(reqheader_param1.validates).to include 'must match format header_param1 pattern'
        expect(reqheader_param1.validates).to include 'must be in email format'
        expect(reqheader_param1.validates).to include 'cannot have length less than 6'
        expect(reqheader_param1.validates).to include 'cannot have length more than 10'
        expect(reqheader_param1.warning).to eq "header_param1 warning"
        expect(reqheader_param1.params).to be_an Array
        expect(reqheader_param1.params.size).to eq 1

        reqheader_param1_1 = reqheader_param1.params.first
        expect(reqheader_param1_1.name).to eq "header_param1_1"
        expect(reqheader_param1_1.type).to eq "Integer"
        expect(reqheader_param1_1.desc).to eq "header_param1_1 desc"
        expect(reqheader_param1_1.permissions.map(&:name)).to eq [ "guest", "member" ]
        expect(reqheader_param1_1.required).to eq false
        expect(reqheader_param1_1.default).to eq "header_param1_1 default"
        expect(reqheader_param1_1.validates).to be_an Array
        expect(reqheader_param1_1.validates).to include 'cannot be less than 5'
        expect(reqheader_param1_1.validates).to include 'cannot be more than 15'
        expect(reqheader_param1_1.validates).to include 'must be within ["c", "d", "e"]'
        expect(reqheader_param1_1.validates).to include 'must match format header_param1_1 pattern'
        expect(reqheader_param1_1.validates).not_to include 'must be in email format'
        expect(reqheader_param1_1.validates).to include 'cannot have length less than 4'
        expect(reqheader_param1_1.validates).to include 'cannot have length more than 6'
        expect(reqheader_param1_1.warning).to eq nil
        expect(reqheader_param1_1.params).to be_an Array
        expect(reqheader_param1_1.params.size).to eq 1

        reqheader_param1_1_1 = reqheader_param1_1.params.first
        expect(reqheader_param1_1_1.name).to eq "header_param1_1_1"
        expect(reqheader_param1_1_1.type).to eq "Integer"
        expect(reqheader_param1_1_1.desc).to eq "header_param1_1_1 desc"
        expect(reqheader_param1_1_1.permissions.map(&:name)).to eq [ "guest", "member" ]
        expect(reqheader_param1_1_1.required).to eq false
        expect(reqheader_param1_1_1.default).to eq "header_param1_1_1 default"
        expect(reqheader_param1_1_1.validates).to be_an Array
        expect(reqheader_param1_1_1.validates).to include 'cannot be less than 5'
        expect(reqheader_param1_1_1.validates).to include 'cannot be more than 15'
        expect(reqheader_param1_1_1.validates).to include 'must be within ["c", "d", "e"]'
        expect(reqheader_param1_1_1.validates).to include 'must match format header_param1_1_1 pattern'
        expect(reqheader_param1_1_1.validates).not_to include 'must be in email format'
        expect(reqheader_param1_1_1.validates).to include 'cannot have length less than 4'
        expect(reqheader_param1_1_1.validates).to include 'cannot have length more than 6'
        expect(reqheader_param1_1_1.warning).to eq nil
        expect(reqheader_param1_1_1.params).to eq []

        expect(request_body).to be_a ParamContainer
        reqbody_param1 = request_body.params.first
        expect(reqbody_param1.name).to eq "body_param1"
        expect(reqbody_param1.type).to eq "String"
        expect(reqbody_param1.desc).to eq "body_param1 desc"
        expect(reqbody_param1.permissions.map(&:name)).to eq ["guest", "admin", "member"]
        expect(reqbody_param1.warning).to eq "body_param1 warning"
        expect(reqbody_param1.params).to eq []

        # response
        expect(api.response).to be_a OpenStruct
        response_header = api.response.header
        expect(response_header).to be_a ParamContainer
        expect(response_header.params).to be_an Array
        expect(response_header.params.size).to eq 1
        response_body = api.response.body
        expect(response_body).to be_a ParamContainer
        expect(response_body.params).to be_an Array
        expect(response_body.params.size).to eq 1

        resheader_param1 = response_header.params.first
        expect(resheader_param1.name).to eq "resheader_param1"
        expect(resheader_param1.type).to eq "String"
        expect(resheader_param1.desc).to eq "resheader_param1 desc"
        expect(resheader_param1.permissions.map(&:name)).to eq ["guest", "admin", "member"]
        expect(resheader_param1.warning).to eq "resheader_param1 warning"
        expect(resheader_param1.params).to eq []

        resbody_param1 = response_body.params.first
        expect(resbody_param1.name).to eq "resbody_param1"
        expect(resbody_param1.type).to eq "String"
        expect(resbody_param1.desc).to eq "resbody_param1 desc"
        expect(resbody_param1.permissions.map(&:name)).to eq ["guest", "admin", "member"]
        expect(resbody_param1.warning).to eq "resbody_param1 warning"
        expect(resbody_param1.params).to eq []

        # errors
        expect(api.errors).to be_an Array
        expect(api.errors.size).to eq 1
        error = api.errors.first
        expect(error.code).to eq 404
        expect(error.message).to eq "Not Found"
        expect(error.permissions.map(&:name)).to eq [ 'guest', 'admin', 'member' ]
        expect(error.params).to be_an Array
        expect(error.params.size).to eq 1
        error_param1 = error.params.first
        expect(error_param1.name).to eq "error_message"
        expect(error_param1.type).to eq "String"
        expect(error_param1.desc).to eq "error message"
        expect(error_param1.permissions.map(&:name)).to eq [ 'guest', 'admin', 'member' ]
      end

      # it "set controller name and version to doc" do
      #   expect(TestApiDoc._controller_name).to eq "orders"
      # end

      # it "set version to doc" do
      #   expect(TestApiDoc._version).to be_a OneboxApiDoc::Version
      #   expect(TestApiDoc._version.version).to eq "1.2.3"
      # end

      # it "set correct api detail" do
      #   expect(TestApiDoc._apis).not_to be_blank
      #   api = TestApiDoc._apis.first
      #   expect(api._action).to eq "show"
      #   expect(api._short_desc).to eq "short_desc"
      #   expect(api._url).to eq "/orders/:id"
      #   expect(api._method).to eq "GET"
      #   expect(api._desc).to eq "description"
      #   expect(api._tags.map { |tag| tag.name }).to eq ["mobile", "web"]
      #   expect(api._permissions).to eq ["guest", "admin", "member"]

      #   expect(api._header).to be_a OneboxApiDoc::Api::Header
      #   header = api._header
      #   expect(header._params).to be_an Array
      #   header_param1 = header._params.first
      #   expect(header_param1._name).to eq "header_param1"
      #   expect(header_param1._type).to eq "String"
      #   expect(header_param1._desc).to eq "header_param1 desc"
      #   expect(header_param1._permissions).to eq ["guest", "admin", "member"]
      #   expect(header_param1._required).to eq true
      #   expect(header_param1._default_value).to eq "header_param1 default"
      #   expect(header_param1._validates).to be_an Array
      #   expect(header_param1._validates).to include 'cannot be less than -1'
      #   expect(header_param1._validates).to include 'cannot be more than 10'
      #   expect(header_param1._validates).to include 'must be within ["a", "b"]'
      #   expect(header_param1._validates).to include 'must match format header_param1 pattern'
      #   expect(header_param1._validates).to include 'must be in email format'
      #   expect(header_param1._validates).to include 'cannot have length less than 6'
      #   expect(header_param1._validates).to include 'cannot have length more than 10'
      #   expect(header_param1._warning).to eq "header_param1 warning"
      #   expect(header_param1._params).to be_an Array
      #   header_param1_1 = header_param1._params.first
      #   expect(header_param1_1._name).to eq "header_param1_1"
      #   expect(header_param1_1._type).to eq "Integer"
      #   expect(header_param1_1._desc).to eq "header_param1_1 desc"
      #   expect(header_param1_1._permissions).to eq [ "guest", "member" ]
      #   expect(header_param1_1._required).to eq false
      #   expect(header_param1_1._default_value).to eq "header_param1_1 default"
      #   expect(header_param1_1._validates).to be_an Array
      #   expect(header_param1_1._validates).to include 'cannot be less than 5'
      #   expect(header_param1_1._validates).to include 'cannot be more than 15'
      #   expect(header_param1_1._validates).to include 'must be within ["c", "d", "e"]'
      #   expect(header_param1_1._validates).to include 'must match format header_param1_1 pattern'
      #   expect(header_param1_1._validates).not_to include 'must be in email format'
      #   expect(header_param1_1._validates).to include 'cannot have length less than 4'
      #   expect(header_param1_1._validates).to include 'cannot have length more than 6'
      #   expect(header_param1_1._warning).to eq nil
      #   expect(header_param1_1._params).to be_an Array

      #   expect(api._body).to be_a OneboxApiDoc::Api::Body
      #   expect(api._response).to be_a OneboxApiDoc::Api::Response
      #   expect(api._error).to be_a OneboxApiDoc::Api::Error
      # end
    end

    describe "class methods" do
      describe "inherited class" do
        it "add api doc object to base class" do
          expect(@base).to receive(:add_doc)
          class InheritedApiDoc < ApiDoc
          end
        end
        it "return correct api doc" do
          api_doc = ApiDoc.inherited(InheritedApiDoc)
          expect(api_doc.resource.name).to eq "inheriteds"
          expect(api_doc.version.name).to eq OneboxApiDoc.base.default_version.name
        end
      end

      describe "controller_name" do
        it "add resource to base class" do
          class ControllerNameApiDoc < ApiDoc
          end
          expect(@base).to receive(:add_resource)
          ControllerNameApiDoc.controller_name :users
        end
        it "set resource_id of api doc" do
          class ControllerNameApiDoc < ApiDoc
            controller_name :users
          end
          expected_resource = @base.resources.detect { |resource| resource.name == "users" }
          doc = @base.docs.detect { |doc| doc.class == ControllerNameApiDoc }
          expect(doc.resource_id).to eq expected_resource.object_id
        end
      end

      describe "extension_name" do
        it "set extension_name of api doc" do
          class ExtensionNameApiDoc < ApiDoc
            extension_name :extension_name
          end
          doc = @base.docs.detect { |doc| doc.class == ExtensionNameApiDoc }
          expect(doc.extension_name).to eq 'extension_name'
        end
      end

      describe "version" do
        it "add version to base class" do
          class VersionApiDoc < ApiDoc
          end
          expect(@base).to receive(:add_version)
          VersionApiDoc.version "0.0.1"
        end
        it "set version_id of api doc" do
          class VersionApiDoc < ApiDoc
            version "0.0.1"
          end
          expected_version = @base.versions.detect { |version| version.name == "0.0.1" }
          doc = @base.docs.detect { |doc| doc.class == VersionApiDoc }
          expect(doc.version_id).to eq expected_version.object_id
        end
      end

      describe "api" do
        before do
          @base.send(:set_default_value)
        end
        it "add api to api doc" do
          class ApiApiDoc < ApiDoc
            controller_name :users
          end
          @doc = @base.docs.select { |doc| doc.class == ApiApiDoc }.first
          @doc.apis = []
          expect(@doc).to receive(:add_api)
          ApiApiDoc.api :show, "get user profile"
        end
        it "set correct api detail" do
          class Api2ApiDoc < ApiDoc
            controller_name :users
            api :show, "get user profile" do
              desc 'get full user profile'
              tags :mobile, :web
              permissions :member
              request do
                header do
                  param :user_id, :string, 
                    desc: 'user id',
                    permissions: [ :member ],
                    required: true
                  param :user_token, :string, 
                    desc: 'user token',
                    permissions: [ :member ],
                    required: true
                end
              end
              response do
                body do
                  param :name, :string, 
                    desc: 'user name',
                    permissions: [ :member ]
                  param :age, :integer, 
                    desc: 'user age',
                    permissions: [ :member ]
                end
              end
              error do
                code 401, "Unauthorize" do
                  permissions :member
                  param :error_status, :integer, 
                    desc: 'error status',
                    permissions: [ :member ]
                  param :error_message, :string, 
                    desc: 'error message',
                    permissions: [ :member ]
                end
              end
            end
          end
          @doc = @base.docs.select { |doc| doc.class == Api2ApiDoc }.first

          expected_tag_ids = @doc.tags.select { |tag| ["mobile", "web"].include? tag.name }.map(&:object_id)
          expected_permission_ids = @doc.permissions.select { |permission| permission.name == "member" }.map(&:object_id)

          api = @doc.apis.first
          expect(api.action).to eq 'show'
          expect(api.short_desc).to eq "get user profile"
          expect(api.desc).to eq "get full user profile"
          expect(api.tag_ids).to eq expected_tag_ids
          expect(api.permission_ids).to eq expected_permission_ids

          api_request = api.request
          expect(api_request.header.params.size).to eq 2
          api_request_header_param1 = api.doc.params.select { |param| param.object_id == api_request.header.param_ids.first }.first
          api_request_header_param2 = api.doc.params.select { |param| param.object_id == api_request.header.param_ids.second }.first
          expect(api_request_header_param1.name).to eq "user_id"
          expect(api_request_header_param1.type).to eq "String"
          expect(api_request_header_param1.desc).to eq "user id"
          expect(api_request_header_param1.permission_ids).to eq expected_permission_ids
          expect(api_request_header_param1.required).to eq true
          expect(api_request_header_param2.name).to eq "user_token"
          expect(api_request_header_param2.type).to eq "String"
          expect(api_request_header_param2.desc).to eq "user token"
          expect(api_request_header_param2.permission_ids).to eq expected_permission_ids
          expect(api_request_header_param2.required).to eq true
          expect(api_request.body.params.size).to eq 0

          api_response = api.response
          expect(api_response.header.params.size).to eq 0
          expect(api_response.body.params.size).to eq 2
          api_response_body_param1 = api.doc.params.select { |param| param.object_id == api_response.body.param_ids.first }.first
          api_response_body_param2 = api.doc.params.select { |param| param.object_id == api_response.body.param_ids.second }.first
          expect(api_response_body_param1.name).to eq "name"
          expect(api_response_body_param1.type).to eq "String"
          expect(api_response_body_param1.desc).to eq "user name"
          expect(api_response_body_param1.permission_ids).to eq expected_permission_ids
          expect(api_response_body_param2.name).to eq "age"
          expect(api_response_body_param2.type).to eq "Integer"
          expect(api_response_body_param2.desc).to eq "user age"
          expect(api_response_body_param2.permission_ids).to eq expected_permission_ids

          expected_error_ids = api.doc.errors.select { |error| error.code == 401 }.map(&:object_id)
          expect(api.error_ids).to eq expected_error_ids
          api_error = api.doc.errors.select { |error| error.object_id == api.error_ids.first }.first
          expect(api_error.code).to eq 401
          expect(api_error.message).to eq "Unauthorize"
          expect(api_error.permission_ids).to eq expected_permission_ids
          expect(api_error.param_ids.size).to eq 2
          api_error_param1 = api.doc.params.select { |param| param.object_id == api_error.param_ids.first }.first
          api_error_param2 = api.doc.params.select { |param| param.object_id == api_error.param_ids.second }.first
          expect(api_error_param1.name).to eq "error_status"
          expect(api_error_param1.type).to eq "Integer"
          expect(api_error_param1.desc).to eq "error status"
          expect(api_error_param1.permission_ids).to eq expected_permission_ids
          expect(api_error_param2.name).to eq "error_message"
          expect(api_error_param2.type).to eq "String"
          expect(api_error_param2.desc).to eq "error message"
          expect(api_error_param2.permission_ids).to eq expected_permission_ids
        end
        it "set api short desc to blank if not send" do
          class Api3ApiDoc < ApiDoc
            controller_name :users
            api :show
          end
          @doc = @base.docs.select { |doc| doc.class == Api3ApiDoc }.first
          api = @doc.apis.select { |api| api.action == 'show' }.first
          expect(api.short_desc).to eq ""
        end
      end
    end

    describe "instance methods" do
      describe "resource" do
        before do
          class ResourceApiDoc < ApiDoc
            controller_name :test_resources
          end
        end
        it "return correct resource" do
          expected_resource = @base.resources.detect { |resource| resource.name == "test_resources" }
          api_doc = @base.docs.detect { |doc| doc.class == OneboxApiDoc::ResourceApiDoc }
          expect(api_doc.resource).to eq expected_resource
        end
      end

      describe "version" do
        before do
          class Version2ApiDoc < ApiDoc
            version :test_version
          end
        end
        it "return correct version" do
          expected_version = @base.versions.detect { |version| version.name == "test_version" }
          api_doc = @base.docs.detect { |doc| doc.class == OneboxApiDoc::Version2ApiDoc }
          expect(api_doc.version).to eq expected_version
        end
      end

      describe "app" do
        before do
          class AppApiDoc < ApiDoc
            version :test_version
          end
        end
        it "return correct app" do
          expected_app = @base.versions.detect { |version| version.name == "test_version" }.app
          api_doc = @base.docs.detect { |doc| doc.class == OneboxApiDoc::AppApiDoc }
          expect(api_doc.app).to eq expected_app
        end
      end

      describe "get_apis" do
        context "action_name is not nil" do
          before do
            class GetApisApiDoc < ApiDoc
              controller_name :users
              api :show, "get user profile"
            end
            @api_doc = @base.docs.detect { |doc| doc.class == OneboxApiDoc::GetApisApiDoc }
          end
          it "return correct api object" do
            api = @api_doc.get_apis(:show)
            expect(api).to be_an OneboxApiDoc::Api
            expect(api.action).to eq 'show'
            expect(api.doc_id).to eq @api_doc.object_id
          end
          it "return nil if api with action does not exist" do
            api = @api_doc.get_apis(:index)
            expect(api).to eq nil
          end
        end
        context "action_name is nil" do
          it "return correct array of api object" do
            class GetApis2ApiDoc < ApiDoc
              controller_name :users
              api :show, "get user profile"
              api :update, "update user profile"
            end
            api_doc = @base.docs.detect { |doc| doc.class == OneboxApiDoc::GetApis2ApiDoc }

            apis = api_doc.get_apis
            expect(apis).to be_an Array
            expect(apis.size).to eq 2
            apis.each do |api|
              expect(api).to be_an OneboxApiDoc::Api
              expect(api.doc_id).to eq api_doc.object_id
            end
          end
          it "return blank array if there is no api" do
            class GetApis3ApiDoc < ApiDoc
            end
            api_doc = @base.docs.detect { |doc| doc.class == OneboxApiDoc::GetApis3ApiDoc }

            apis = api_doc.get_apis
            expect(apis).to eq []
          end
        end
      end

      describe "add_api" do
        before do
          class AddApiApiDoc < ApiDoc
            controller_name :products
          end
        end
        it "add new api to doc.apis" do
          api_doc = @base.docs.detect { |doc| doc.class == OneboxApiDoc::AddApiApiDoc }
          expect{ api_doc.add_api(:show, 'sample short description') }.to change(api_doc.apis, :count).by 1
        end
        it "add correct api" do
          api_doc = @base.docs.detect { |doc| doc.class == OneboxApiDoc::AddApiApiDoc }
          api_doc.add_api(:show, 'sample short description')
          api = api_doc.apis.last
          expect(api.doc_id).to eq api_doc.object_id
          expect(api.method).to eq "GET"
          expect(api.action).to eq "show"
          expect(api.url).to eq "/products/:id"
          expect(api.short_desc).to eq "sample short description"
        end
        it "return correct api" do
          api_doc = @base.docs.detect { |doc| doc.class == OneboxApiDoc::AddApiApiDoc }
          api = api_doc.add_api(:index, 'sample short description')
          expect(api.doc_id).to eq api_doc.object_id
          expect(api.method).to eq "GET"
          expect(api.action).to eq "index"
          expect(api.url).to eq "/products"
          expect(api.short_desc).to eq "sample short description"
        end
      end

      describe "add_param" do
        before do
          class AddParamApiDoc < ApiDoc
            controller_name :products
          end
        end
        it "add new param to doc.params" do
          api_doc = @base.docs.detect { |doc| doc.class == OneboxApiDoc::AddParamApiDoc }
          expect{ api_doc.add_param(:param0, :integer) }.to change(api_doc.params, :count).by 1
        end
        it "add correct param" do
          api_doc = @base.docs.detect { |doc| doc.class == OneboxApiDoc::AddParamApiDoc }
          api_doc.add_param(:param1, :string)
          param = api_doc.params.last
          expect(param.doc_id).to eq api_doc.object_id
          expect(param.name).to eq 'param1'
          expect(param.type).to eq 'String'
        end
        it "return correct param" do
          api_doc = @base.docs.detect { |doc| doc.class == OneboxApiDoc::AddParamApiDoc }
          param = api_doc.add_param(:param2, :float)
          expect(param.doc_id).to eq api_doc.object_id
          expect(param.name).to eq 'param2'
          expect(param.type).to eq 'Float'
        end
      end

      describe "add_error" do
        before do
          class AddErrorApiDoc < ApiDoc
            controller_name :products
          end
          api_doc = @base.docs.detect { |doc| doc.class == OneboxApiDoc::AddErrorApiDoc }
          @api = api_doc.add_api(:index, 'get all products')
        end
        it "add new error to doc.errors" do
          api_doc = @base.docs.detect { |doc| doc.class == OneboxApiDoc::AddErrorApiDoc }
          expect{ api_doc.add_error(@api, 401, 'Unauthorize') }.to change(api_doc.errors, :count).by 1
        end
        it "add correct error" do
          api_doc = @base.docs.detect { |doc| doc.class == OneboxApiDoc::AddErrorApiDoc }
          api_doc.add_error(@api, 401, 'Unauthorize')
          error = api_doc.errors.last
          expect(error.doc_id).to eq api_doc.object_id
          expect(error.code).to eq 401
          expect(error.message).to eq 'Unauthorize'
        end
        it "return correct error" do
          api_doc = @base.docs.detect { |doc| doc.class == OneboxApiDoc::AddErrorApiDoc }
          error = api_doc.add_error(@api, 401, 'Unauthorize')
          expect(error.doc_id).to eq api_doc.object_id
          expect(error.code).to eq 401
          expect(error.message).to eq 'Unauthorize'
        end
        it "init ErrorDefinition to get data from block if block given" do
          api_doc = @base.docs.detect { |doc| doc.class == OneboxApiDoc::AddErrorApiDoc }
          expect_any_instance_of(OneboxApiDoc::ApiDefinition::ErrorDefinition).to receive :permissions
          error = api_doc.add_error(@api, 401, 'Unauthorize') do
            permissions :guest, :admin, :member
            param :error_message, :string, 
              desc: 'error message',
              permissions: [ :guest, :admin, :member ]
          end
        end
        it 'set correct data from block if block given' do
          api_doc = @base.docs.detect { |doc| doc.class == OneboxApiDoc::AddErrorApiDoc }
          error = api_doc.add_error(@api, 401, 'Unauthorize') do
            permissions :guest, :admin, :member
            param :error_message, :string, 
              desc: 'error message',
              permissions: [ :guest, :admin, :member ]
          end
          expect(error.doc_id).to eq api_doc.object_id
          expect(error.code).to eq 401
          expect(error.message).to eq 'Unauthorize'
          expect(error.param_ids.size).to eq 1
          expect(error.permission_ids.size).to eq 3
        end
      end

      describe "add_tag" do
        before do
          class AddTagApiDoc < ApiDoc
            controller_name :products
          end
          @api_doc = @base.docs.detect { |doc| doc.class == OneboxApiDoc::AddTagApiDoc }
          @api_doc.tags = []
        end
        it "add new tag to doc.tags" do
          expect{ @api_doc.add_tag(:tag_name) }.to change(@api_doc.tags, :count).by 1
        end
        it "dose not add new tag to doc.tags if tag with this name already exist" do
          @api_doc.add_tag(:tag_name)
          expect{ @api_doc.add_tag(:tag_name) }.not_to change(@api_doc.tags, :count)
        end
        it "add correct tag" do
          @api_doc.add_tag(:tag_name)
          tag = @api_doc.tags.detect { |tag| tag.name == 'tag_name' }
          expect(tag.name).to eq 'tag_name'
        end
        it "return correct tag" do
          tag = @api_doc.add_tag(:tag_name)
          expect(tag.name).to eq 'tag_name'
        end
      end

      describe "add_permission" do
        before do
          class AddTagApiDoc < ApiDoc
            controller_name :products
          end
          @api_doc = @base.docs.detect { |doc| doc.class == OneboxApiDoc::AddTagApiDoc }
          @api_doc.permissions = []
        end
        it "add new permission to doc.permissions" do
          expect{ @api_doc.add_permission(:permission_name) }.to change(@api_doc.permissions, :count).by 1
        end
        it "dose not add new permission to doc.permissions if permission with this name already exist" do
          @api_doc.add_permission(:permission_name)
          expect{ @api_doc.add_permission(:permission_name) }.not_to change(@api_doc.permissions, :count)
        end
        it "add correct permission" do
          @api_doc.add_permission(:permission_name)
          permission = @api_doc.permissions.detect { |permission| permission.name == 'permission_name' }
          expect(permission.name).to eq 'permission_name'
        end
        it "return correct permission" do
          permission = @api_doc.add_permission(:permission_name)
          expect(permission.name).to eq 'permission_name'
        end
      end

      describe "nested_params_of" do
        before do
          class NestedParamApiDoc < ApiDoc
          end
          @api_doc = @base.docs.detect { |doc| doc.class == OneboxApiDoc::NestedParamApiDoc }
        end
        it "return correct array of params which are child of given param id" do
          parent_param = @api_doc.add_param :user, :object do
            param :user_name, :string
            param :user_age, :integer
            param :user_bd, :date
          end
          nested_params = @api_doc.nested_params_of parent_param.object_id
          expect(nested_params).to be_an Array
          expect(nested_params.size).to eq 3
          nested_params.each do |param|
            expect(param).to be_an OneboxApiDoc::Param
            expect(param.parent_id).to eq parent_param.object_id
          end
          param1 = nested_params.first
          expect(param1.name).to eq 'user_name'
          expect(param1.type).to eq 'String'
          param2 = nested_params.second
          expect(param2.name).to eq 'user_age'
          expect(param2.type).to eq 'Integer'
          param3 = nested_params.third
          expect(param3.name).to eq 'user_bd'
          expect(param3.type).to eq 'Date'
        end
        it "return blank array if param with the given id have no child" do
          parent_param = @api_doc.add_param :order, :object
          nested_params = @api_doc.nested_params_of parent_param.object_id
          expect(nested_params).to eq []
        end
        it "return blank array if param with the given id does not exist" do
          nested_params = @api_doc.nested_params_of :fake_id
          expect(nested_params).to eq []
        end
      end
    end

    # describe "controller_name" do
    #   class ControllerNameApiDoc < ApiDoc
    #     controller_name :test_controller_names
    #   end
    #   it "set correct controller name" do
    #     expect(ControllerNameApiDoc._controller_name).to eq "test_controller_names"
    #   end

    #   class WithoutControllerNameApiDoc < ApiDoc
    #   end
    #   it "set controller name according to class name if not calling" do
    #     expect(WithoutControllerNameApiDoc._controller_name).to eq "without_controller_names"
    #   end
    # end

    # describe "version" do
    #   class VersionApiDoc < ApiDoc
    #     version "0.0.1"
    #   end
    #   it "set correct version" do
    #     expect(VersionApiDoc._version).to be_a OneboxApiDoc::Version
    #     expect(VersionApiDoc._version.version).to eq "0.0.1"
    #   end

    #   class WithoutVersionApiDoc < ApiDoc
    #   end
    #   it "set version to default version" do
    #     expect(WithoutVersionApiDoc._version).to be_a OneboxApiDoc::Version
    #     expect(WithoutVersionApiDoc._version.version).to eq OneboxApiDoc.base.default_version.version
    #   end

    #   it "set correct core versions if it is extension api doc"
    # end

    # describe "api" do
    #   before do
    #     @base = OneboxApiDoc.base

    #     class ApiApiDoc < ApiDoc
    #       controller_name :orders
    #       api :show, 'short_desc' do
    #         desc 'description'
    #         tags :mobile, :web
    #         permissions :guest, :admin, :member
    #         header do
    #         end
    #         body do
    #         end
    #         response do
    #         end
    #         error do
    #         end
    #       end
    #       api :update, 'short_desc' do
    #         desc 'description'
    #         tags :mobile, :web
    #         permissions :guest, :admin, :member
    #         header do
    #         end
    #         body do
    #         end
    #         response do
    #         end
    #         error do
    #         end
    #       end
    #     end
    #   end

    #   it "set correct apis" do
    #     api = ApiApiDoc._apis
    #     expect(api).to be_an Array
    #     expect(api.size).to eq 2
    #     api1 = api.first
    #     expect(api1._action).to eq "show"
    #     expect(api1._short_desc).to eq "short_desc"
    #     expect(api1._url).to eq "/orders/:id"
    #     expect(api1._method).to eq "GET"
    #     expect(api1._desc).to eq "description"
    #     expect(api1._tags.map { |tag| tag.name }).to eq ["mobile", "web"]
    #     expect(api1._permissions).to eq ["guest", "admin", "member"]
    #     api2 = api.last
    #     expect(api2._action).to eq "update"
    #     expect(api2._short_desc).to eq "short_desc"
    #     expect(api2._url).to eq "/orders/:id"
    #     expect(api2._method).to eq "PATCH"
    #     expect(api2._desc).to eq "description"
    #     expect(api2._tags.map { |tag| tag.name }).to eq ["mobile", "web"]
    #     expect(api2._permissions).to eq ["guest", "admin", "member"]
    #   end
    #   it "add api to base apis" do
    #     apis = ApiApiDoc._apis
    #     apis.each do |api|
    #       expect(@base.all_apis).to include api
    #     end
    #   end
    #   it "add api to version" do
    #     apis = ApiApiDoc._apis
    #     apis.each do |api|
    #       expect(ApiApiDoc._version.apis).to include api
    #     end
    #   end
    # end

    # describe "def_param_group" do

    #   before do
    #     @base = OneboxApiDoc.base
    #     class DefParamGroupApiDoc < ApiDoc
    #       def_param_group :user_header do
    #         param :user_id, :string, 
    #           desc: 'user id',
    #           permissions: :member,
    #           required: true
    #         param :user_type, :string, 
    #           desc: 'user type',
    #           permissions: :member,
    #           required: true
    #         param :user_auth, :string, 
    #           desc: 'user authentication',
    #           permissions: :member,
    #           required: true
    #       end
    #     end
    #   end

    #   it "add param group to base" do
    #     expect(@base.param_groups).to be_an Hash
    #     expect(@base.param_groups.keys).to include "user_header"
    #   end
    # end

    # describe "param_group" do
    #   before do
    #     OneboxApiDoc.base.add_param_group :user_header do
    #       param :user_id, :string, 
    #         desc: 'user id',
    #         permissions: :member,
    #         required: true
    #       param :user_type, :string, 
    #         desc: 'user type',
    #         permissions: :member,
    #         required: true
    #       param :user_auth, :string, 
    #         desc: 'user authentication',
    #         permissions: :member,
    #         required: true
    #     end

    #     class ParamGroupApiDoc < ApiDoc
    #       controller_name :orders
    #       api :show, 'short_desc' do
    #         desc 'description'
    #         tags :mobile, :web
    #         permissions :guest, :admin, :member
    #         header do
    #           param_group :user_header
    #         end
    #         body do
    #         end
    #         response do
    #         end
    #         error do
    #         end
    #       end
    #       api :update, 'short_desc' do
    #         desc 'description'
    #         tags :mobile, :web
    #         permissions :guest, :admin, :member
    #         header do
    #           param_group :user_header
    #         end
    #         body do
    #         end
    #         response do
    #         end
    #         error do
    #         end
    #       end
    #     end
    #   end

    #   it "add param group to base" do
    #     api = ParamGroupApiDoc._apis
    #     expect(api).to be_an Array
    #     expect(api.size).to eq 2
    #     api1 = api.first
    #     expect(api1._action).to eq "show"
    #     expect(api1._short_desc).to eq "short_desc"
    #     expect(api1._url).to eq "/orders/:id"
    #     expect(api1._method).to eq "GET"
    #     expect(api1._desc).to eq "description"
    #     expect(api1._tags.map { |tag| tag.name }).to eq ["mobile", "web"]
    #     expect(api1._permissions).to eq ["guest", "admin", "member"]
    #     api1_header_params = api1._header._params
    #     expect(api1_header_params).to be_an Array
    #     expect(api1_header_params.size).to eq 3
    #     api1_header_params1 = api1_header_params.shift
    #     expect(api1_header_params1._name).to eq "user_id"
    #     expect(api1_header_params1._type).to eq "String"
    #     expect(api1_header_params1._desc).to eq "user id"
    #     expect(api1_header_params1._permissions).to eq ["member"]
    #     expect(api1_header_params1._required).to eq true
    #     api1_header_params2 = api1_header_params.shift
    #     expect(api1_header_params2._name).to eq "user_type"
    #     expect(api1_header_params2._type).to eq "String"
    #     expect(api1_header_params2._desc).to eq "user type"
    #     expect(api1_header_params2._permissions).to eq ["member"]
    #     expect(api1_header_params2._required).to eq true
    #     api1_header_params3 = api1_header_params.shift
    #     expect(api1_header_params3._name).to eq "user_auth"
    #     expect(api1_header_params3._type).to eq "String"
    #     expect(api1_header_params3._desc).to eq "user authentication"
    #     expect(api1_header_params3._permissions).to eq ["member"]
    #     expect(api1_header_params3._required).to eq true

    #     api2 = api.last
    #     expect(api2._action).to eq "update"
    #     expect(api2._short_desc).to eq "short_desc"
    #     expect(api2._url).to eq "/orders/:id"
    #     expect(api2._method).to eq "PATCH"
    #     expect(api2._desc).to eq "description"
    #     expect(api2._tags.map { |tag| tag.name }).to eq ["mobile", "web"]
    #     expect(api2._permissions).to eq ["guest", "admin", "member"]
    #     api2_header_params = api2._header._params
    #     expect(api2_header_params).to be_an Array
    #     expect(api2_header_params.size).to eq 3
    #     api2_header_params1 = api2_header_params.shift
    #     expect(api2_header_params1._name).to eq "user_id"
    #     expect(api2_header_params1._type).to eq "String"
    #     expect(api2_header_params1._desc).to eq "user id"
    #     expect(api2_header_params1._permissions).to eq ["member"]
    #     expect(api2_header_params1._required).to eq true
    #     api2_header_params2 = api2_header_params.shift
    #     expect(api2_header_params2._name).to eq "user_type"
    #     expect(api2_header_params2._type).to eq "String"
    #     expect(api2_header_params2._desc).to eq "user type"
    #     expect(api2_header_params2._permissions).to eq ["member"]
    #     expect(api2_header_params2._required).to eq true
    #     api2_header_params3 = api2_header_params.shift
    #     expect(api2_header_params3._name).to eq "user_auth"
    #     expect(api2_header_params3._type).to eq "String"
    #     expect(api2_header_params3._desc).to eq "user authentication"
    #     expect(api2_header_params3._permissions).to eq ["member"]
    #     expect(api2_header_params3._required).to eq true
    #   end
    # end

  end
end