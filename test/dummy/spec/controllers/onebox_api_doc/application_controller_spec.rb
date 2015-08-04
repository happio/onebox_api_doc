require "rails_helper"

module OneboxApiDoc
  describe OneboxApiDoc::ApplicationController, :type => :controller do
    routes { OneboxApiDoc::Engine.routes }

    let(:developer) { @developer ||= OneboxApiDoc::Developer.create(email: 'test@gmail.com', password: '11111111', password_confirmation: '11111111')}
    
    describe "GET index" do
      describe "authentication" do
        context "enable auth" do
          before do
            OneboxApiDoc::Engine.auth_method = "authenticate_developer!"
          end
          it "redirect to developer sign in when unauthentication" do
            get :index
            expect(response.status).to eq 302
            expect(response).to redirect_to '/developers/sign_in'
          end
          it "access page when sign in already" do
            sign_in(:developer, developer)
            get :index
            expect(response.status).to eq 200
            expect(response).to render_template :index
          end
        end
        context "disable auth" do
          before do
            OneboxApiDoc::Engine.auth_method = nil
          end
          after do
            get :index
            expect(response.status).to eq 200
            expect(response).to render_template :index
          end
          it "access page when not sign in" do
          end
          it "access page when sign in already" do
            sign_in(:developer, developer)
          end
        end
      end
    end

    describe "GET index /:tag" do
      let(:valid_params) {
        @valid_params = {
          tag: 'web'
        }
      }
      describe "authentication" do
        context "enable auth" do
          before do
            OneboxApiDoc::Engine.auth_method = "authenticate_developer!"
          end
          it "redirect to developer sign in when unauthentication" do
            get :index, valid_params
            expect(response.status).to eq 302
            expect(response).to redirect_to '/developers/sign_in'
          end
          it "access page when sign in already" do
            sign_in(:developer, developer)
            get :index, valid_params
            expect(response.status).to eq 200
            expect(response).to render_template :index
          end
        end
        context "disable auth" do
          before do
            OneboxApiDoc::Engine.auth_method = nil
          end
          after do
            get :index, valid_params
            expect(response.status).to eq 200
            expect(response).to render_template :index
          end
          it "access page when not sign in" do
          end
          it "access page when sign in already" do
            sign_in(:developer, developer)
          end
        end
      end
    end

    describe "GET show /:version/:tag/:resource_name/:method/:url" do
      let(:valid_params) { 
        @valid_params = {
          :version       => '1.0.0',
          :tag           => 'web',
          :resource_name => 'products',
          :method        => 'get',
          :url           =>  ''
        }
      }
      describe "authentication" do
        context "enable auth" do
          before do
            OneboxApiDoc::Engine.auth_method = "authenticate_developer!"
          end
          it "redirect to developer sign in when unauthentication" do
            get :show, valid_params
            expect(response.status).to eq 302
            expect(response).to redirect_to '/developers/sign_in'
          end
          it "access page when sign in already" do
            sign_in(:developer, developer)
            get :show, valid_params
            expect(response.status).to eq 200
            expect(response).to render_template :show
          end
        end
        context "disable auth" do
          before do
            OneboxApiDoc::Engine.auth_method = nil
          end
          after do
            get :show, valid_params
            expect(response.status).to eq 200
            expect(response).to render_template :show
          end
          it "access page when not sign in" do
          end
          it "access page when sign in already" do
            sign_in(:developer, developer)
          end
        end
      end
    end

  end
end
    # describe "GET index" do

    #   before do
    #     @base = OneboxApiDoc.base
    #     @base.reload_document
    #   end
      
    #   it "set @main_versions" do
    #     get :index
    #     main_versions = assigns(:main_versions)
    #     expect(main_versions).to be_an Array
    #     expect(main_versions).to eq @base.main_versions
    #     expect(main_versions.size).to be > 0 and eq @base.main_versions.size
    #     main_versions.each do |version|
    #       expect(version).to be_an OneboxApiDoc::Version
    #       expect(version.is_extension?).to eq false
    #     end
    #   end

    #   it "set @default_version" do
    #     get :index
    #     default_version = assigns(:default_version)
    #     expect(default_version).to be_an OneboxApiDoc::Version
    #     expect(default_version).to eq @base.default_version
    #   end

    #   it "set @main_app" do
    #     get :index
    #     main_app = assigns(:main_app)
    #     expect(main_app).to be_an OneboxApiDoc::App
    #     expect(main_app).to eq @base.main_app
    #   end

    #   it "set @current_version to default version if params[:version] is nil" do
    #     get :index
    #     current_version = assigns(:current_version)
    #     expect(current_version).to be_an OneboxApiDoc::Version
    #     expect(current_version).to eq @base.default_version
    #   end

    #   it "set @tags according to doc with default version" do
    #     get :index
    #     tags = assigns(:tags)
    #     expect(tags).to be_an Array
    #     doc = @base.get_doc @base.default_version.name
    #     expect(tags).to eq doc.tags
    #   end

    #   it "set @apis_group_by_resource according to doc with default version" do
    #     get :index
    #     apis_group_by_resource = assigns(:apis_group_by_resource)
    #     expect(apis_group_by_resource).to be_a Hash
    #     doc = @base.get_doc @base.default_version.name
    #     expect(apis_group_by_resource.keys.size).to be > 0
    #     expect(apis_group_by_resource.keys).to eq doc.resources.map(&:name)
    #     apis_group_by_resource.each do |key, value|
    #       expected_value = doc.apis.select { |api| api.resource.name == key }
    #       expect(value).to be_an Array
    #       expect(value).to eq expected_value
    #       expect(value.size).to be > 0 and eq expected_value.size
    #       value.each do |api|
    #         expect(api).to be_an OneboxApiDoc::Api
    #         expect(api.resource.name).to eq key
    #         expect(api.version.name).to eq doc.version.name
    #       end
    #     end
    #   end
    #   it "set @api to empty array" do
    #     get :index
    #     expect(assigns(:api)).to eq []
    #   end

    #   context "request with version" do
    #     it "set @current_version to specified version" do
    #       get :index, { version: "0.0.1" }
    #       current_version = assigns(:current_version)
    #       expect(current_version).to be_an OneboxApiDoc::Version
    #       expect(current_version.name).to eq '0.0.1'
    #     end
    #     it "set @tags according to doc with specified version" do
    #       get :index, { version: "0.0.1" }
    #       tags = assigns(:tags)
    #       expect(tags).to be_an Array
    #       doc = @base.get_doc "0.0.1"
    #       expect(tags).to eq doc.tags
    #     end
    #     it "set @apis_group_by_resource according to doc with specified version" do
    #       get :index, { version: "0.0.1" }
    #       apis_group_by_resource = assigns(:apis_group_by_resource)
    #       expect(apis_group_by_resource).to be_a Hash
    #       doc = @base.get_doc "0.0.1"
    #       expect(apis_group_by_resource.keys.size).to be > 0
    #       expect(apis_group_by_resource.keys).to eq doc.resources.map(&:name)
    #       apis_group_by_resource.each do |key, value|
    #         expected_value = doc.apis.select { |api| api.resource.name == key }
    #         expect(value).to be_an Array
    #         expect(value).to eq expected_value
    #         expect(value.size).to be > 0 and eq expected_value.size
    #         value.each do |api|
    #           expect(api).to be_an OneboxApiDoc::Api
    #           expect(api.resource.name).to eq key
    #           expect(api.version.name).to eq '0.0.1'
    #         end
    #       end
    #     end
    #     it "set @api to empty array" do
    #       get :index, { version: "0.0.1" }
    #       expect(assigns(:api)).to eq []
    #     end
    #   end

    #   context "request with version and resource name" do
    #     it "set @current_version to specified version" do
    #       get :index, { version: "0.0.1", resource_name: :products }
    #       current_version = assigns(:current_version)
    #       expect(current_version).to be_an OneboxApiDoc::Version
    #       expect(current_version.name).to eq '0.0.1'
    #     end
    #     it "set @tags according to doc with specified version" do
    #       get :index, { version: "0.0.1", resource_name: :products }
    #       tags = assigns(:tags)
    #       expect(tags).to be_an Array
    #       doc = @base.get_doc "0.0.1"
    #       expect(tags).to eq doc.tags
    #     end
    #     it "set @apis_group_by_resource according to doc with specified version" do
    #       get :index, { version: "0.0.1", resource_name: :products }
    #       apis_group_by_resource = assigns(:apis_group_by_resource)
    #       expect(apis_group_by_resource).to be_a Hash
    #       doc = @base.get_doc "0.0.1"
    #       expect(apis_group_by_resource.keys.size).to be > 0
    #       expect(apis_group_by_resource.keys).to eq doc.resources.map(&:name)
    #       apis_group_by_resource.each do |key, value|
    #         expected_value = doc.apis.select { |api| api.resource.name == key }
    #         expect(value).to be_an Array
    #         expect(value).to eq expected_value
    #         expect(value.size).to be > 0 and eq expected_value.size
    #         value.each do |api|
    #           expect(api).to be_an OneboxApiDoc::Api
    #           expect(api.resource.name).to eq key
    #           expect(api.version.name).to eq '0.0.1'
    #         end
    #       end
    #     end
    #     it "set @api to apis of specified resource" do
    #       get :index, { version: "0.0.1", resource_name: :products }
    #       expect_apis = doc = @base.get_doc("0.0.1").apis.select { |api| api.resource.name == 'products' }
    #       apis = assigns(:api)
    #       expect(apis).to eq expect_apis
    #       expect(apis.size).to be > 0 and eq expect_apis.size
    #       apis.each do |api|
    #         expect(api).to be_an OneboxApiDoc::Api
    #         expect(api.resource.name).to eq 'products'
    #         expect(api.version.name).to eq '0.0.1'
    #       end
    #     end
    #   end

    #   context "request with version, resource name and action name" do
    #     it "set @current_version to specified version" do
    #       get :index, { version: "0.0.1", resource_name: :products, action_name: :show }
    #       current_version = assigns(:current_version)
    #       expect(current_version).to be_an OneboxApiDoc::Version
    #       expect(current_version.name).to eq '0.0.1'
    #     end
    #     it "set @tags according to doc with specified version" do
    #       get :index, { version: "0.0.1", resource_name: :products }
    #       tags = assigns(:tags)
    #       expect(tags).to be_an Array
    #       doc = @base.get_doc "0.0.1"
    #       expect(tags).to eq doc.tags
    #     end
    #     it "set @apis_group_by_resource according to doc with specified version" do
    #       get :index, { version: "0.0.1", resource_name: :products, action_name: :show }
    #       apis_group_by_resource = assigns(:apis_group_by_resource)
    #       expect(apis_group_by_resource).to be_a Hash
    #       doc = @base.get_doc "0.0.1"
    #       expect(apis_group_by_resource.keys.size).to be > 0
    #       expect(apis_group_by_resource.keys).to eq doc.resources.map(&:name)
    #       apis_group_by_resource.each do |key, value|
    #         expected_value = doc.apis.select { |api| api.resource.name == key }
    #         expect(value).to be_an Array
    #         expect(value).to eq expected_value
    #         expect(value.size).to be > 0 and eq expected_value.size
    #         value.each do |api|
    #           expect(api).to be_an OneboxApiDoc::Api
    #           expect(api.resource.name).to eq key
    #           expect(api.version.name).to eq '0.0.1'
    #         end
    #       end
    #     end
    #     it "set @api to api of specified resource and action" do
    #       get :index, { version: "0.0.1", resource_name: :products, action_name: :show }
    #       expect_apis = doc = @base.get_doc("0.0.1").apis.select { |api| api.resource.name == 'products' }
    #       api = assigns(:api)
    #       expect(api).to be_an OneboxApiDoc::Api
    #       expect(api.resource.name).to eq 'products'
    #       expect(api.version.name).to eq '0.0.1'
    #       expect(api.action).to eq 'show'
    #     end
    #   end

    # end
#   end
# end