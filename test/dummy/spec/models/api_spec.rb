require "rails_helper"

module OneboxApiDoc
  describe Api do
    before do
      @base = OneboxApiDoc.base
      @base.send(:set_default_value)
      @version = @base.default_version
      @resource = @base.add_resource :product
      @doc = @base.add_doc(@version.object_id)
    end

    describe "initialize" do
      it "set correct id and api detail" do
        api = OneboxApiDoc::Api.new doc_id: @doc.object_id, action: :show, method: :get, 
          url: "/users/:id", short_desc: "get user profile", desc: "description",
          tag_ids: [3,5,7,9], error_ids: [5,6,7,8], permission_ids: [9,8,7,6], resource_id: @resource.object_id
        expect(api).not_to eq nil
        expect(api.doc_id).to eq @doc.object_id
        expect(api.resource_id).to eq @resource.object_id
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
          url: "/users/:id", short_desc: "get user profile", resource_id: @resource.object_id
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
          tag_ids: [3,5,7,9], error_ids: [5,6,7,8], resource_id: @resource.object_id
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
          tag_ids: [3,5,7,9], error_ids: [5,6,7,8], resource_id: @resource.object_id
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
          tag_ids: [3,5,7,9], error_ids: [5,6,7,8], resource_id: @resource.object_id
      end
      it "return correct version" do
        version = @api.version
        expect(version).to eq @version
      end
    end

    describe "tags" do
      before do
        @tags = []
        @tags << @doc.add_tag(:tag1, 'Tag 1')
        @tags << @doc.add_tag(:tag2, 'Tag 2')
        @tags << @doc.add_tag(:tag3, 'Tag 3')
        @api = OneboxApiDoc::Api.new doc_id: @doc.object_id, action: :show, method: :get, 
          url: "/users/:id", short_desc: "get user profile", desc: "description",
          tag_ids: @tags.map(&:object_id), error_ids: [5,6,7,8], resource_id: @resource.object_id
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
        @permissions << @doc.add_permission(:permission1, 'Permission 1')
        @permissions << @doc.add_permission(:permission2, 'Permission 2')
        @permissions << @doc.add_permission(:permission3, 'Permission 3')
        @api = OneboxApiDoc::Api.new doc_id: @doc.object_id, action: :show, method: :get, 
          url: "/users/:id", short_desc: "get user profile", desc: "description", resource_id: @resource.object_id,
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
          tag_ids: [3,5,7,9], permission_ids: [5,6,7,8], resource_id: @resource.object_id
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
        @doc = @base.add_doc(@version.object_id)
        @api = OneboxApiDoc::Api.new doc_id: @doc.object_id, action: :show
        expect(@api.is_extension?).to eq false
      end
      it "return false if its version is main version" do
        @version = @base.add_extension_version '0.3', :extension_name
        @resource = @base.add_resource :product
        @doc = @base.add_doc(@version.object_id)
        @api = OneboxApiDoc::Api.new doc_id: @doc.object_id, action: :show, resource_id: @resource.object_id
        expect(@api.is_extension?).to eq true
      end
    end
    
  end
end