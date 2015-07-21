require "rails_helper"

module OneboxApiDoc
  describe ApiDoc, focus: true do

    before do
      @base = OneboxApiDoc.base
    end

    describe "overall" do
      before do
        class TestApiDoc < ApiDoc
          resource_name :products
          version "1.2.3"

          def_tags do
            tag :mobile, 'Mobile'
            tag :web, 'Web', default: true
          end

          def_permissions do
            permission :admin, 'Admin'
            permission :member, 'Member'
            permission :guest, 'Guest'
          end

          get '/products', 'product detail' do
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
        @doc = @base.docs.last
      end

      it "set correct api detail" do
        expect(@doc.resources).to be_an Array
        expect(@doc.resources.size).to eq 1
        expect(@doc.resources.first.name).to eq 'products'

        expect(@doc.version).to be_an OneboxApiDoc::Version
        expect(@doc.version.name).to eq "1.2.3"

        expect(@doc.apis).not_to be_blank
        api = @doc.apis.first
        expect(api.short_desc).to eq "product detail"
        expect(api.url).to eq "/products"
        expect(api.method).to eq "GET"
        expect(api.desc).to eq "get product detail"
        expect(api.tags.map(&:slug)).to eq ["mobile", "web"]
        expect(api.permissions.map(&:slug)).to eq ["admin", "member", "guest"]

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
        expect(reqheader_param1.permissions.map(&:slug)).to eq ["admin", "member", "guest"]
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
        expect(reqheader_param1_1.permissions.map(&:slug)).to eq ["member", "guest"]
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
        expect(reqheader_param1_1_1.permissions.map(&:slug)).to eq ["member", "guest"]
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
        expect(reqbody_param1.permissions.map(&:slug)).to eq ["admin", "member", "guest"]
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
        expect(resheader_param1.permissions.map(&:slug)).to eq ["admin", "member", "guest"]
        expect(resheader_param1.warning).to eq "resheader_param1 warning"
        expect(resheader_param1.params).to eq []

        resbody_param1 = response_body.params.first
        expect(resbody_param1.name).to eq "resbody_param1"
        expect(resbody_param1.type).to eq "String"
        expect(resbody_param1.desc).to eq "resbody_param1 desc"
        expect(resbody_param1.permissions.map(&:slug)).to eq ["admin", "member", "guest"]
        expect(resbody_param1.warning).to eq "resbody_param1 warning"
        expect(resbody_param1.params).to eq []

        # errors
        expect(api.errors).to be_an Array
        expect(api.errors.size).to eq 1
        error = api.errors.first
        expect(error.code).to eq 404
        expect(error.message).to eq "Not Found"
        expect(error.permissions.map(&:slug)).to eq ["admin", "member", "guest"]
        expect(error.params).to be_an Array
        expect(error.params.size).to eq 1
        error_param1 = error.params.first
        expect(error_param1.name).to eq "error_message"
        expect(error_param1.type).to eq "String"
        expect(error_param1.desc).to eq "error message"
        expect(error_param1.permissions.map(&:slug)).to eq ["admin", "member", "guest"]
      end
    end

    describe "class methods" do
      describe "inherited class" do
        it "set resource name" do
          class InheritedApiDoc < ApiDoc
          end
          expect(InheritedApiDoc._resource_name).to eq 'inheriteds'
        end
        it "set version_id if parent's version_id is nil" do
          OneboxApiDoc::ApiDoc.version_id = nil
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

      describe "resource_name" do
        it "set resource_name of ApiDoc" do
          class ControllerNameApiDoc < ApiDoc
            resource_name :users
          end
          expect(ControllerNameApiDoc._resource_name).not_to eq 'users'
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
            resource_name :users
          end
          expect_any_instance_of(OneboxApiDoc::Doc).to receive(:add_api)
          ApiApiDoc.get '/users/:id', "get user profile"
        end
        it "set correct api detail" do
          class Api2ApiDoc < ApiDoc
            resource_name :users
            def_tags do
              tag :mobile, 'Mobile'
              tag :web, 'Web', default: true
            end

            def_permissions do
              permission :admin, 'Admin'
              permission :member, 'Member'
              permission :guest, 'Guest'
            end

            get '/users', "get user profile" do
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

          expected_tag_ids = @doc.tags.select { |tag| ["mobile", "web"].include? tag.slug.to_s }.map(&:object_id)
          expected_permission_ids = @doc.permissions.select { |permission| permission.slug == "member" }.map(&:object_id)

          api = @doc.apis.first
          expect(api.url).to eq '/users'
          expect(api.method).to eq 'GET'
          expect(api.short_desc).to eq "get user profile"
          expect(api.desc).to eq "get full user profile"
          expect(api.tag_ids).to eq expected_tag_ids
          expect(api.permission_ids).to eq expected_permission_ids

          api_request = api.request
          expect(api_request.header.params.size).to eq 2
          api_request_header_param1 = api_request.header.params.first
          api_request_header_param2 = api_request.header.params.second
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
          api_response_body_param1 = api_response.body.params.first
          api_response_body_param2 = api_response.body.params.second
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
          expect(api_error.params.size).to eq 2
          api_error_param1 = api_error.params.first
          api_error_param2 = api_error.params.second
          expect(api_error_param1.name).to eq "error_status"
          expect(api_error_param1.type).to eq "Integer"
          expect(api_error_param1.desc).to eq "error status"
          expect(api_error_param1.permission_ids).to eq expected_permission_ids
          expect(api_error_param2.name).to eq "error_message"
          expect(api_error_param2.type).to eq "String"
          expect(api_error_param2.desc).to eq "error message"
          expect(api_error_param2.permission_ids).to eq expected_permission_ids
        end
        it "set correct api request and response" do
          class Api3ApiDoc < ApiDoc
            resource_name :users

            def_permissions do
              permission :admin, 'Admin'
              permission :member, 'Member'
              permission :guest, 'Guest'
            end

            get '/user/:id', "get user profile" do
              request do
                header do
                  param :header_obj, :object,
                    desc: 'header id',
                    permissions: [ :member ],
                    required: true do
                      param :header_child, :object,
                        desc: 'header child',
                        permissions: [ :member ],
                        required: true do
                          param :header_subchild, :string,
                            desc: 'header subchild',
                            permissions: [ :member ],
                            required: true
                        end
                    end
                end
              end
              response do
                body do
                  param :body_obj, :object,
                    desc: 'body object',
                    permissions: [ :member ] do
                      param :body_child, :object,
                        desc: 'body child',
                        permissions: [ :member ] do
                          param :body_subchild, :string,
                            desc: 'body subchild',
                            permissions: [ :member ]
                        end
                    end
                end
              end
            end
          end
          @doc = @base.docs.last
          api = @doc.apis.first
          request = api.request
          request_header = request.header
          expect(request_header).to be_an OneboxApiDoc::ParamContainer
          expect(request_header.params.size).to eq 1
          expect(request_header.params.first.name).to eq 'header_obj'
          expect(request_header.params.first.params.size).to eq 1
          expect(request_header.params.first.params.first.name).to eq 'header_child'
          expect(request_header.params.first.params.first.params.size).to eq 1
          expect(request_header.params.first.params.first.params.first.name).to eq 'header_subchild'

          request_body = request.body
          expect(request_body).to be_an OneboxApiDoc::ParamContainer
          expect(request_body.params.size).to eq 0

          response = api.response
          response_header = response.header
          expect(response_header).to be_an OneboxApiDoc::ParamContainer
          expect(response_header.params.size).to eq 0

          response_body = response.body
          expect(response_body).to be_an OneboxApiDoc::ParamContainer
          expect(response_body.params.size).to eq 1
          expect(response_body.params.first.name).to eq 'body_obj'
          expect(response_body.params.first.params.size).to eq 1
          expect(response_body.params.first.params.first.name).to eq 'body_child'
          expect(response_body.params.first.params.first.params.size).to eq 1
          expect(response_body.params.first.params.first.params.first.name).to eq 'body_subchild'
        end
        it "set api short desc to blank if not send" do
          class Api4ApiDoc < ApiDoc
            resource_name :users
            get '/users/:id'
          end
          @doc = @base.docs.last
          api = @doc.apis.select { |api| api.url == '/users/:id' }.first
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
            resource_name :users
            get '/users/:id', ''
          end
          class ResourceApi2Doc < ApiDoc
            resource_name :products
            get '/products/:id', ''
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
            resource_name :users
            get '/users'
          end
        end
        it "return correct app" do
          expected_app = @base.versions.detect { |version| version.name == "test_version" }.app
          doc = @base.docs.last
          expect(doc.app).to eq expected_app
        end
      end

      describe "apis_group_by_resource" do
        before do
          @base.send(:set_default_value)
        end
        it "return hash with resource names as key and array of apis as value" do
          class ApiGroupByResourceApiDoc < ApiDoc
            resource_name :users
            get '/users/:id', ""
            put '/users/:id', ""
          end
          class ApiGroupByResource2ApiDoc < ApiDoc
            resource_name :products
            get '/products', ""
            get '/products/:id', ""
            put '/products/:id', ""
          end
          doc = @base.docs.last

          api_hash = doc.apis_group_by_resource
          expect(api_hash).to be_an Hash
          expect(api_hash.keys.sort).to eq ['users', 'products'].sort

          expect(api_hash['users'].size).to eq 2
          expect(api_hash['products'].size).to eq 3
          
          user_apis = api_hash['users']
          user_apis.each do |api|
            expect(api).to be_an OneboxApiDoc::Api
            expect(api.resource.name).to eq 'users'
            expect(api.version_id).to eq doc.version_id
          end

          product_apis = api_hash['products']
          product_apis.each do |api|
            expect(api).to be_an OneboxApiDoc::Api
            expect(api.resource.name).to eq 'products'
            expect(api.version_id).to eq doc.version_id
          end
         
        end
      end

      describe "get_api" do
        before do
          @base.send(:set_default_value)
        end
        context "action_name is not nil" do
          it "return correct api object" do
            class GetApisApiDoc < ApiDoc
              resource_name :users
              get '/users/:id', "get user profile"
            end
            doc = @base.docs.last

            api = doc.get_api(:users, :get, '/users/:id')
            expect(api).to be_an OneboxApiDoc::Api
            expect(api.resource.name).to eq 'users'
            expect(api.method).to eq 'GET'
            expect(api.url).to eq '/users/:id'
            expect(api.doc_id).to eq doc.object_id
          end
          it "return nil if api with method does not exist" do
            class GetApis1ApiDoc < ApiDoc
              resource_name :users
              get '/users', "get user profile"
            end
            doc = @base.docs.last

            api = doc.get_api(:users, :post, '/users')
            expect(api).to eq nil
          end

          it "return nil if api with url does not exist" do
            class GetApis2ApiDoc < ApiDoc
              resource_name :users
              get '/users', "get user profile"
            end
            doc = @base.docs.last

            api = doc.get_api(:users, :get, '/not_found')
            expect(api).to eq nil
          end
        end
        
      end

      describe "get_apis_by_resource" do
        context "apis of resource" do
          it "return correct array of api object" do
            class GetApis2ApiDoc < ApiDoc
              resource_name :users
              get '/users', "get user profile"
              put '/users/:id', "update user profile"
            end
            doc = @base.docs.last

            apis = doc.get_apis_by_resource(:users)
            expect(apis).to be_an Array
            expect(apis.size).to eq 2
            apis.each do |api|
              expect(api).to be_an OneboxApiDoc::Api
              expect(api.resource.name).to eq 'users'
              expect(api.doc_id).to eq doc.object_id
            end
          end
          it "return blank array if there is no api" do
            class GetApis3ApiDoc < ApiDoc
            end
            doc = @base.add_doc(@base.default_version)
            apis = doc.get_apis_by_resource(:users)
            expect(apis).to eq []
          end
        end
      end

      describe "add_api" do
        before do
          class AddApiApiDoc < ApiDoc
            resource_name :products
          end
          @resource = @base.add_resource :products
        end
        it "add new api to doc.apis" do
          doc = @base.docs.last
          expect{ doc.add_api(@resource.object_id, 'GET', '/url', 'sample short description') }.to change(doc.apis, :count).by 1
        end
        it "add correct api" do
          doc = @base.docs.last
          doc.add_api(@resource.object_id, 'GET', '/url', 'sample short description')
          api = doc.apis.last
          expect(api.doc_id).to eq doc.object_id
          expect(api.method).to eq "GET"
          expect(api.url).to eq "/url"
          expect(api.short_desc).to eq "sample short description"
        end
        it "return api object" do
          doc = @base.docs.last
          api = doc.add_api(@resource.object_id, 'POST', '/url', 'sample short description')
          expect(api).to be_an OneboxApiDoc::Api
          expect(api.doc_id).to eq doc.object_id
          expect(api.method).to eq "POST"
          expect(api.url).to eq "/url"
          expect(api.short_desc).to eq "sample short description"
        end
      end

      describe "add_param" do
        before do
          class AddParamApiDoc < ApiDoc
            resource_name :products
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
            resource_name :products
          end
          doc = @base.docs.last
          @resource = @base.add_resource :products
          @api = doc.add_api(@resource.object_id, "GET", '/products', 'get all products')
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
          doc.add_permission :admin, 'Admin'
          doc.add_permission :member, 'Member'
          doc.add_permission :guest, 'Guest'
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
          doc.add_permission :admin, 'Admin'
          doc.add_permission :member, 'Member'
          doc.add_permission :guest, 'Guest'
          error = doc.add_error(@api, 401, 'Unauthorize') do
            permissions :guest, :admin, :member
            param :error_message, :string, 
              desc: 'error message',
              permissions: [ :guest, :admin, :member ]
          end
          expect(error.doc_id).to eq doc.object_id
          expect(error.code).to eq 401
          expect(error.message).to eq 'Unauthorize'
          expect(error.permission_ids.size).to eq 3
        end
      end

      describe "def_tags" do
        before do
          class DefTagsApiDoc < ApiDoc
            version 'test_def_tags'
            resource_name :def_tags

            def_tags do
              tag :tag1, 'Tag 1', default: true
              tag :tag2, 'Tag 2'
              tag :tag3, 'Tag 3'
            end
          end
          @doc = @base.docs.last
        end
        it "add tags to doc" do
          expect(@doc.tags.size).to eq 3
          expect(@doc.tags.map(&:name)).to eq ['Tag 1', 'Tag 2', 'Tag 3']
          expect(@doc.tags.map(&:slug)).to eq ['tag1', 'tag2', 'tag3']
          expect(@doc.tags.detect { |tag| tag.default }.slug).to eq 'tag1'
        end
      end

      describe "add_tag" do
        before do
          class AddTagApiDoc < ApiDoc
            resource_name :products
          end
          @doc = @base.docs.last
          @doc.tags = []
        end
        it "add new tag to doc.tags" do
          expect{ @doc.add_tag(:tag_slug, 'Tag Slug') }.to change(@doc.tags, :count).by 1
        end
        it "add correct tag" do
          @doc.add_tag(:tag_slug, 'Tag Slug', default: true)
          tag = @doc.tags.detect { |tag| tag.slug == 'tag_slug' }
          expect(tag.name).to eq 'Tag Slug'
          expect(tag.default).to eq true
        end
        it "return correct tag" do
          tag = @doc.add_tag(:tag_slug, 'Tag Slug', default: true)
          expect(tag.name).to eq 'Tag Slug'
          expect(tag.default).to eq true
        end
      end

      describe "default_tag" do
        before do
          class DefaultTagApiDoc < ApiDoc
            resource_name :products
            version '0.0.0.4'
            def_tags do
              tag :tag1, 'Tag 1'
              tag :tag2, 'Tag 2', default: true
              tag :tag3, 'Tag 3'
            end
          end
          @doc = @base.get_doc('0.0.0.4')
        end
        it "return correct default tag" do
          tag = @doc.default_tag
          expect(tag).not_to eq nil
          expect(tag.name).to eq 'Tag 2'
          expect(tag.slug).to eq 'tag2'
        end
      end

      describe "get_tag" do
        before do
          class GetTagApiDoc < ApiDoc
            resource_name :products

            def_tags do
              tag :tag1, 'Tag 1', default: true
              tag :tag2, 'Tag 2'
              tag :tag3, 'Tag 3'
            end
          end
          @doc = @base.docs.last
        end
        it "return correct tag" do
          tag = @doc.get_tag :tag2
          expect(tag).not_to eq nil
          expect(tag.name).to eq 'Tag 2'
          expect(tag.slug).to eq 'tag2'
        end
        it "return nil if tag with slug does not exist" do
          expect{ @doc.get_tag :fake_tag }.to raise_error
        end
      end

      describe "def_permissions" do
        before do
          class DefPermissionsApiDoc < ApiDoc
            resource_name :products
            version '0.0.21'
            def_permissions do
              permission :permission1, 'Permission 1'
              permission :permission2, 'Permission 2'
              permission :permission3, 'Permission 3'
            end
          end
          @doc = @base.get_doc('0.0.21')
        end
        it "add permissions to doc" do
          expect(@doc.permissions.size).to eq 3
          expect(@doc.permissions.map(&:name)).to eq ['Permission 1', 'Permission 2', 'Permission 3']
          expect(@doc.permissions.map(&:slug)).to eq ['permission1', 'permission2', 'permission3']
        end
      end

      describe "add_permission" do
        before do
          class AddPermissionApiDoc < ApiDoc
            resource_name :products
          end
          @doc = @base.docs.last
          @doc.permissions = []
        end
        it "add new permission to doc.permissions" do
          expect{ @doc.add_permission(:permission, 'Permission Name') }.to change(@doc.permissions, :count).by 1
        end
        it "dose not add new permission to doc.permissions if permission with this name already exist" do
          @doc.add_permission(:permission, 'Permission Name')
          expect{ @doc.add_permission(:permission, 'Permission Name') }.not_to change(@doc.permissions, :count)
        end
        it "add correct permission" do
          @doc.add_permission(:permission, 'Permission Name')
          permission = @doc.permissions.detect { |permission| permission.slug == 'permission' }
          expect(permission.name).to eq 'Permission Name'
          expect(permission.slug).to eq 'permission'
        end
        it "return correct permission" do
          permission = @doc.add_permission(:permission, 'Permission Name')
          expect(permission.name).to eq 'Permission Name'
          expect(permission.slug).to eq 'permission'
        end
      end

      describe "get_permission" do
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

      describe "annoucements" do
        before do
          class GetAnnoucementsApiDoc < ApiDoc
            version '1.2.2'
            resource_name :users
            put '/users/:id', "update user profile" do
              response do
                body do
                  param :test, :string, warning: 'test warning'
                end
              end
            end
            get '/users/:id', "get user profile" do
              response do
                body do
                  param :test_res_header, :string, warning: 'test_res_header'
                end
                body do
                  param :test_res_body, :string, warning: 'test_res_body'
                end
              end
              response do
                body do
                  param :test_res_header, :string, warning: 'test_res_header'
                end
                body do
                  param :test_res_body, :string, warning: 'test_res_body'
                end
              end
            end
          end
          @doc = @base.docs.last
        end
        it "add annoucements" do
          expect(@doc.annoucements.size).to eq 5
        end
        it "is annoucement object" do
          @doc.annoucements.each do |annoucement|
            expect(annoucement).to be_an OneboxApiDoc::Annoucements::Param
          end
        end
        it "has param's warning" do
          @doc.annoucements.each do |annoucement|
            expect(annoucement.message).to eq annoucement.param.warning
          end
        end
      end
    end

    describe "param group methods" do
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
          class DefParamGroupApiDoc < ApiDoc
            version '0.0.0.90'
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
          @doc = @base.get_doc('0.0.0.90')
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
            resource_name :orders

            def_tags do
              tag :mobile, 'Mobile'
              tag :web, 'Web', default: true
            end

            def_permissions do
              permission :admin, 'Admin'
              permission :member, 'Member'
              permission :guest, 'Guest'
            end

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

            get '/orders/:id', 'short_desc' do
              desc 'description'
              tags :mobile, :web
              permissions :guest, :admin, :member
              request do
                header do
                  param_group :user_header
                end
              end
            end
            put '/orders/:id', 'short_desc' do
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
          expect(api1.short_desc).to eq "short_desc"
          expect(api1.url).to eq "/orders/:id"
          expect(api1.method).to eq "GET"
          expect(api1.desc).to eq "description"
          expect(api1.tags.map(&:slug)).to eq ["mobile", "web"]
          expect(api1.permissions.map(&:slug)).to eq ["admin", "member", "guest"]
          api1_header_params = api1.request.header.params
          expect(api1_header_params).to be_an Array
          expect(api1_header_params.size).to eq 3
          api1_header_params1 = api1_header_params.shift
          expect(api1_header_params1.name).to eq "user_id"
          expect(api1_header_params1.type).to eq "String"
          expect(api1_header_params1.desc).to eq "user id"
          expect(api1_header_params1.permissions.map(&:slug)).to eq ["member"]
          expect(api1_header_params1.required).to eq true
          api1_header_params2 = api1_header_params.shift
          expect(api1_header_params2.name).to eq "user_type"
          expect(api1_header_params2.type).to eq "String"
          expect(api1_header_params2.desc).to eq "user type"
          expect(api1_header_params2.permissions.map(&:slug)).to eq ["member"]
          expect(api1_header_params2.required).to eq true
          api1_header_params3 = api1_header_params.shift
          expect(api1_header_params3.name).to eq "user_auth"
          expect(api1_header_params3.type).to eq "String"
          expect(api1_header_params3.desc).to eq "user authentication"
          expect(api1_header_params3.permissions.map(&:slug)).to eq ["member"]
          expect(api1_header_params3.required).to eq true

          api2 = apis.last
          expect(api2.short_desc).to eq "short_desc"
          expect(api2.url).to eq "/orders/:id"
          expect(api2.method).to eq "PUT"
          expect(api2.desc).to eq "description"
          expect(api2.tags.map(&:slug)).to eq ["mobile", "web"]
          expect(api2.permissions.map(&:slug)).to eq ["admin", "member", "guest"]
          api2_header_params = api2.request.header.params
          expect(api2_header_params).to be_an Array
          expect(api2_header_params.size).to eq 3
          api2_header_params1 = api2_header_params.shift
          expect(api2_header_params1.name).to eq "user_id"
          expect(api2_header_params1.type).to eq "String"
          expect(api2_header_params1.desc).to eq "user id"
          expect(api2_header_params1.permissions.map(&:slug)).to eq ["member"]
          expect(api2_header_params1.required).to eq true
          api2_header_params2 = api2_header_params.shift
          expect(api2_header_params2.name).to eq "user_type"
          expect(api2_header_params2.type).to eq "String"
          expect(api2_header_params2.desc).to eq "user type"
          expect(api2_header_params2.permissions.map(&:slug)).to eq ["member"]
          expect(api2_header_params2.required).to eq true
          api2_header_params3 = api2_header_params.shift
          expect(api2_header_params3.name).to eq "user_auth"
          expect(api2_header_params3.type).to eq "String"
          expect(api2_header_params3.desc).to eq "user authentication"
          expect(api2_header_params3.permissions.map(&:slug)).to eq ["member"]
          expect(api2_header_params3.required).to eq true
        end
      end
    end

    describe "error group methods" do
      describe "add_error_group" do
        before do
          class AddErrorGroupApiDoc < ApiDoc
          end
          @doc = @base.docs.last
        end
        it "add error group to doc" do
          @doc.add_error_group :error_group1 do
            puts "do something"
          end
          expect(@doc.error_groups.keys).to include "error_group1"
          expect(@doc.error_groups["error_group1"]).to be_a Proc
        end
      end

      describe "get_error_group"do
        before do
          class GetErrorGroupApiDoc < ApiDoc
          end
          @doc = @base.docs.last
          @block = Proc.new { puts "do something" }
          @doc.error_groups["sample_error_group"] = @block
        end
        it "return correct error group" do
          error_group = @doc.get_error_group :sample_error_group
          expect(error_group).to be_a Proc
          expect(error_group).to eq @block
        end
      end

      describe "def_error_group" do
        before do
          class DefErrorGroupApiDoc < ApiDoc
            def_error_group :update_errors do
              code 401, 'Unauthorized'
              code 404, 'Not Found'
            end
          end
          @doc = @base.docs.last
        end
        it "add error group to doc" do
          expect(@doc.error_groups).to be_an Hash
          expect(@doc.error_groups.keys).to include "update_errors"
        end
      end

      describe "error_group" do
        before do
          @base.send(:set_default_value)
          class ErrorGroupApiDoc < ApiDoc
            resource_name :orders

            def_error_group :show_errors do
              code 401, 'Unauthorized'
              code 404, 'Not Found'
            end

            get '/orders/:id', 'short_desc' do
              desc 'description'
              error do
                error_group :show_errors
              end
            end
            put '/orders/:id', 'short_desc' do
              desc 'description'
              error do
                error_group :show_errors
                code 422, 'Cannot Update'
              end
            end
          end
          @doc = @base.docs.last
        end
        it "add error to api" do
          apis = @doc.apis
          expect(apis).to be_an Array
          expect(apis.size).to eq 2
          api1 = apis.first
          expect(api1.errors.size).to eq 2
          error1 = api1.errors.first
          expect(error1.code).to eq 401
          expect(error1.message).to eq 'Unauthorized'
          error2 = api1.errors.second
          expect(error2.code).to eq 404
          expect(error2.message).to eq 'Not Found'

          api2 = apis.second
          expect(api2.errors.size).to eq 3
          error1 = api2.errors.first
          expect(error1.code).to eq 401
          expect(error1.message).to eq 'Unauthorized'
          error2 = api2.errors.second
          expect(error2.code).to eq 404
          expect(error2.message).to eq 'Not Found'
          error3 = api2.errors.third
          expect(error3.code).to eq 422
          expect(error3.message).to eq 'Cannot Update'
        end
      end
    end

  end
end