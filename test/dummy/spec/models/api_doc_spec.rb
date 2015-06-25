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
        # @doc = @base.docs.detect { |doc| doc.class == TestApiDoc }
        @doc = @base.docs.last
      end

      it "set resources to doc" do
        expect(@doc.resources).to be_an Array
        expect(@doc.resources.size).to eq 1
        expect(@doc.resources.first.name).to eq 'products'
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
    end

    describe "class methods" do
      describe "inherited class" do
        it "set resource name" do
          class InheritedApiDoc < ApiDoc
          end
          expect(InheritedApiDoc.resource_name).to eq 'inheriteds'
        end
        it "set version_id" do
          class Inherited2ApiDoc < ApiDoc
          end
          expect(Inherited2ApiDoc.version_id).to eq @base.default_version.object_id
        end
        it "clear doc" do
          class Inherited3ApiDoc < ApiDoc
          end
          expect(Inherited3ApiDoc.doc).to eq nil
        end
      end

      describe "controller_name" do
        it "set resource_name of ApiDoc" do
          class ControllerNameApiDoc < ApiDoc
            controller_name :users
          end
          expect(ControllerNameApiDoc.resource_name).not_to eq 'users'
        end
      end

      describe "extension_name" do
        it "set extension_name of api doc" do
          class ExtensionNameApiDoc < ApiDoc
            extension_name :extension_name
          end
          expect(ExtensionNameApiDoc._extension_name).to eq 'extension_name'
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
          expect(VersionApiDoc.version_id).to eq expected_version.object_id
        end
      end

      describe "api" do
        before do
          @base.send(:set_default_value)
        end
        it "add api to api doc and init Doc" do
          class ApiApiDoc < ApiDoc
            controller_name :users
          end
          expect_any_instance_of(OneboxApiDoc::Doc).to receive(:add_api)
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
          @doc = @base.docs.last

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
          @doc = @base.docs.last
          api = @doc.apis.select { |api| api.action == 'show' }.first
          expect(api.short_desc).to eq ""
        end
      end
    end

    describe "instance methods" do
      describe "resources" do
        before do
          @base.send(:set_default_value)
        end
        it "return correct resource" do
          class ResourceApiDoc < ApiDoc
            controller_name :users
            api :show, ''
          end
          class ResourceApi2Doc < ApiDoc
            controller_name :products
            api :show, ''
          end

          doc = @base.docs.last
          expected_resource = [
            @base.resources.detect { |resource| resource.name == "users" },
            @base.resources.detect { |resource| resource.name == "products" }
          ]
          expect(doc.resources).to eq expected_resource
        end
      end

      describe "version" do
        before do
          class Version2ApiDoc < ApiDoc
            version :test_version
          end
        end
        it "return correct version" do
          version = Version2ApiDoc.version :test_version
          expect(version.name).to eq 'test_version'
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
          doc = @base.docs.last
          expect(doc.app).to eq expected_app
        end
      end

      describe "get_apis" do
        before do
          @base.send(:set_default_value)
        end
        context "action_name is not nil" do
          it "return correct api object" do
            class GetApisApiDoc < ApiDoc
              controller_name :users
              api :show, "get user profile"
            end
            doc = @base.docs.last

            api = doc.get_apis(:users, :show)
            expect(api).to be_an OneboxApiDoc::Api
            expect(api.action).to eq 'show'
            expect(api.resource.name).to eq 'users'
            expect(api.doc_id).to eq doc.object_id
          end
          it "return nil if api with action does not exist" do
            class GetApis1ApiDoc < ApiDoc
              controller_name :users
              api :show, "get user profile"
            end
            doc = @base.docs.last

            api = doc.get_apis(:users, :index)
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
            doc = @base.docs.last

            apis = doc.get_apis(:users)
            expect(apis).to be_an Array
            expect(apis.size).to eq 2
            apis.each do |api|
              expect(api).to be_an OneboxApiDoc::Api
              expect(api.doc_id).to eq doc.object_id
            end
          end
          it "return blank array if there is no api" do
            class GetApis3ApiDoc < ApiDoc
            end
            doc = @base.add_doc(@base.default_version)
            apis = doc.get_apis(:users)
            expect(apis).to eq []
          end
        end
      end

      describe "add_api" do
        before do
          class AddApiApiDoc < ApiDoc
            controller_name :products
          end
          @resource = @base.add_resource :products
        end
        it "add new api to doc.apis" do
          doc = @base.docs.last
          expect{ doc.add_api(@resource.object_id, :show, 'sample short description') }.to change(doc.apis, :count).by 1
        end
        it "add correct api" do
          doc = @base.docs.last
          doc.add_api(@resource.object_id, :show, 'sample short description')
          api = doc.apis.last
          expect(api.doc_id).to eq doc.object_id
          expect(api.method).to eq "GET"
          expect(api.action).to eq "show"
          expect(api.url).to eq "/products/:id"
          expect(api.short_desc).to eq "sample short description"
        end
        it "return correct api" do
          doc = @base.docs.last
          api = doc.add_api(@resource.object_id, :index, 'sample short description')
          expect(api.doc_id).to eq doc.object_id
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
          doc = @base.docs.last
          expect{ doc.add_param(:param0, :integer) }.to change(doc.params, :count).by 1
        end
        it "add correct param" do
          doc = @base.docs.last
          doc.add_param(:param1, :string)
          param = doc.params.last
          expect(param.doc_id).to eq doc.object_id
          expect(param.name).to eq 'param1'
          expect(param.type).to eq 'String'
        end
        it "return correct param" do
          doc = @base.docs.last
          param = doc.add_param(:param2, :float)
          expect(param.doc_id).to eq doc.object_id
          expect(param.name).to eq 'param2'
          expect(param.type).to eq 'Float'
        end
      end

      describe "add_error" do
        before do
          class AddErrorApiDoc < ApiDoc
            controller_name :products
          end
          doc = @base.docs.last
          @resource = @base.add_resource :products
          @api = doc.add_api(@resource.object_id, :index, 'get all products')
        end
        it "add new error to doc.errors" do
          doc = @base.docs.last
          expect{ doc.add_error(@api, 401, 'Unauthorize') }.to change(doc.errors, :count).by 1
        end
        it "add correct error" do
          doc = @base.docs.last
          doc.add_error(@api, 401, 'Unauthorize')
          error = doc.errors.last
          expect(error.doc_id).to eq doc.object_id
          expect(error.code).to eq 401
          expect(error.message).to eq 'Unauthorize'
        end
        it "return correct error" do
          doc = @base.docs.last
          error = doc.add_error(@api, 401, 'Unauthorize')
          expect(error.doc_id).to eq doc.object_id
          expect(error.code).to eq 401
          expect(error.message).to eq 'Unauthorize'
        end
        it "init ErrorDefinition to get data from block if block given" do
          doc = @base.docs.last
          expect_any_instance_of(OneboxApiDoc::ApiDefinition::ErrorDefinition).to receive :permissions
          error = doc.add_error(@api, 401, 'Unauthorize') do
            permissions :guest, :admin, :member
            param :error_message, :string, 
              desc: 'error message',
              permissions: [ :guest, :admin, :member ]
          end
        end
        it 'set correct data from block if block given' do
          doc = @base.docs.last
          error = doc.add_error(@api, 401, 'Unauthorize') do
            permissions :guest, :admin, :member
            param :error_message, :string, 
              desc: 'error message',
              permissions: [ :guest, :admin, :member ]
          end
          expect(error.doc_id).to eq doc.object_id
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
          @doc = @base.docs.last
          @doc.tags = []
        end
        it "add new tag to doc.tags" do
          expect{ @doc.add_tag(:tag_name) }.to change(@doc.tags, :count).by 1
        end
        it "dose not add new tag to doc.tags if tag with this name already exist" do
          @doc.add_tag(:tag_name)
          expect{ @doc.add_tag(:tag_name) }.not_to change(@doc.tags, :count)
        end
        it "add correct tag" do
          @doc.add_tag(:tag_name)
          tag = @doc.tags.detect { |tag| tag.name == 'tag_name' }
          expect(tag.name).to eq 'tag_name'
        end
        it "return correct tag" do
          tag = @doc.add_tag(:tag_name)
          expect(tag.name).to eq 'tag_name'
        end
      end

      describe "add_permission" do
        before do
          class AddTagApiDoc < ApiDoc
            controller_name :products
          end
          @doc = @base.docs.last
          @doc.permissions = []
        end
        it "add new permission to doc.permissions" do
          expect{ @doc.add_permission(:permission_name) }.to change(@doc.permissions, :count).by 1
        end
        it "dose not add new permission to doc.permissions if permission with this name already exist" do
          @doc.add_permission(:permission_name)
          expect{ @doc.add_permission(:permission_name) }.not_to change(@doc.permissions, :count)
        end
        it "add correct permission" do
          @doc.add_permission(:permission_name)
          permission = @doc.permissions.detect { |permission| permission.name == 'permission_name' }
          expect(permission.name).to eq 'permission_name'
        end
        it "return correct permission" do
          permission = @doc.add_permission(:permission_name)
          expect(permission.name).to eq 'permission_name'
        end
      end

      describe "nested_params_of" do
        before do
          class NestedParamApiDoc < ApiDoc
          end
          @doc = @base.docs.last
        end
        it "return correct array of params which are child of given param id" do
          parent_param = @doc.add_param :user, :object do
            param :user_name, :string
            param :user_age, :integer
            param :user_bd, :date
          end
          nested_params = @doc.nested_params_of parent_param.object_id
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
          parent_param = @doc.add_param :order, :object
          nested_params = @doc.nested_params_of parent_param.object_id
          expect(nested_params).to eq []
        end
        it "return blank array if param with the given id does not exist" do
          nested_params = @doc.nested_params_of :fake_id
          expect(nested_params).to eq []
        end
      end
    end

    describe "add_param_group" do
      before do
        class AddParamGroupApiDoc < ApiDoc
        end
        @doc = @base.docs.last
      end
      it "add param group" do
        @doc.add_param_group :sample do
          puts "do something"
        end
        expect(@doc.param_groups.keys).to include "sample"
        expect(@doc.param_groups["sample"]).to be_a Proc
      end
    end

    describe "get_param_group" do
      before do
        class AddParamGroupApiDoc < ApiDoc
        end
        @doc = @base.docs.last
        @block = Proc.new { puts "do something" }
        @doc.param_groups["sample"] = @block
      end
      it "return correct proc" do
        param_group = @doc.get_param_group :sample
        expect(param_group).to be_a Proc
        expect(param_group).to eq @block
      end
    end

    describe "def_param_group" do

      before do
        @base = OneboxApiDoc.base
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
        @doc = @base.docs.last
      end

      it "add param group to base" do
        expect(@doc.param_groups).to be_an Hash
        expect(@doc.param_groups.keys).to include "user_header"
      end
    end

    describe "param_group" do
      before do
        @base.send(:set_default_value)
        class ParamGroupApiDoc < ApiDoc
          controller_name :orders

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

          api :show, 'short_desc' do
            desc 'description'
            tags :mobile, :web
            permissions :guest, :admin, :member
            request do
              header do
                param_group :user_header
              end
            end
          end
          api :update, 'short_desc' do
            desc 'description'
            tags :mobile, :web
            permissions :guest, :admin, :member
            request do
              header do
                param_group :user_header
              end
            end
          end
        end
        @doc = @base.docs.last
      end

      it "add param group to base" do
        apis = @doc.apis
        expect(apis).to be_an Array
        expect(apis.size).to eq 2
        api1 = apis.first
        expect(api1.action).to eq "show"
        expect(api1.short_desc).to eq "short_desc"
        expect(api1.url).to eq "/orders/:id"
        expect(api1.method).to eq "GET"
        expect(api1.desc).to eq "description"
        expect(api1.tags.map(&:name)).to eq ["mobile", "web"]
        expect(api1.permissions.map(&:name)).to eq ["guest", "admin", "member"]
        api1_header_params = api1.request.header.params
        expect(api1_header_params).to be_an Array
        expect(api1_header_params.size).to eq 3
        api1_header_params1 = api1_header_params.shift
        expect(api1_header_params1.name).to eq "user_id"
        expect(api1_header_params1.type).to eq "String"
        expect(api1_header_params1.desc).to eq "user id"
        expect(api1_header_params1.permissions.map(&:name)).to eq ["member"]
        expect(api1_header_params1.required).to eq true
        api1_header_params2 = api1_header_params.shift
        expect(api1_header_params2.name).to eq "user_type"
        expect(api1_header_params2.type).to eq "String"
        expect(api1_header_params2.desc).to eq "user type"
        expect(api1_header_params2.permissions.map(&:name)).to eq ["member"]
        expect(api1_header_params2.required).to eq true
        api1_header_params3 = api1_header_params.shift
        expect(api1_header_params3.name).to eq "user_auth"
        expect(api1_header_params3.type).to eq "String"
        expect(api1_header_params3.desc).to eq "user authentication"
        expect(api1_header_params3.permissions.map(&:name)).to eq ["member"]
        expect(api1_header_params3.required).to eq true

        api2 = apis.last
        expect(api2.action).to eq "update"
        expect(api2.short_desc).to eq "short_desc"
        expect(api2.url).to eq "/orders/:id"
        expect(api2.method).to eq "PATCH"
        expect(api2.desc).to eq "description"
        expect(api2.tags.map(&:name)).to eq ["mobile", "web"]
        expect(api2.permissions.map(&:name)).to eq ["guest", "admin", "member"]
        api2_header_params = api2.request.header.params
        expect(api2_header_params).to be_an Array
        expect(api2_header_params.size).to eq 3
        api2_header_params1 = api2_header_params.shift
        expect(api2_header_params1.name).to eq "user_id"
        expect(api2_header_params1.type).to eq "String"
        expect(api2_header_params1.desc).to eq "user id"
        expect(api2_header_params1.permissions.map(&:name)).to eq ["member"]
        expect(api2_header_params1.required).to eq true
        api2_header_params2 = api2_header_params.shift
        expect(api2_header_params2.name).to eq "user_type"
        expect(api2_header_params2.type).to eq "String"
        expect(api2_header_params2.desc).to eq "user type"
        expect(api2_header_params2.permissions.map(&:name)).to eq ["member"]
        expect(api2_header_params2.required).to eq true
        api2_header_params3 = api2_header_params.shift
        expect(api2_header_params3.name).to eq "user_auth"
        expect(api2_header_params3.type).to eq "String"
        expect(api2_header_params3.desc).to eq "user authentication"
        expect(api2_header_params3.permissions.map(&:name)).to eq ["member"]
        expect(api2_header_params3.required).to eq true
      end
    end

  end
end