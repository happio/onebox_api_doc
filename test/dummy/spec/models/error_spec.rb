require "rails_helper"

module OneboxApiDoc
  describe Error do
    before do
      @base = OneboxApiDoc.base
      @base.send(:set_default_value)
      version = @base.default_version
      @resource = @base.add_resource :products
      @doc = @base.add_doc(version.object_id)
    end

    describe "initialize" do
      it "set correct doc_id, code and message" do
        error = OneboxApiDoc::Error.new doc_id: @doc.object_id, code: 404, message: "Not Found"
        expect(error).not_to eq nil
        expect(error.doc_id).to eq @doc.object_id
        expect(error.code).to eq 404
        expect(error.message).to eq "Not Found"
      end
      it "set correct code, message, permission_ids and param_ids" do
        error = OneboxApiDoc::Error.new doc_id: @doc.object_id, code: 404, message: "Not Found", permission_ids: [1,3,5], param_ids: [2,4,6]
        expect(error).not_to eq nil
        expect(error.code).to eq 404
        expect(error.message).to eq "Not Found"
        expect(error.permission_ids).to eq [1,3,5]
        expect(error.param_ids).to eq [2,4,6]
      end
    end

    describe "doc" do
      it "return correct doc" do
        error = OneboxApiDoc::Error.new doc_id: @doc.object_id, code: 404, message: "Not Found"
        doc = error.doc
        expect(doc).to eq @doc
      end
    end

    describe "params" do
      it "return correct params array" do
        api = OneboxApiDoc::Api.new(doc_id: @doc.object_id, resource_id: @resource.object_id)
        error = @doc.add_error api, 404, "Not Found" do
          param :error_status, :integer
          param :error_message, :string
        end
        params = error.params
        expect(params).to be_an Array
        expect(params.size).to eq 2
        param1 = params.first
        expect(param1).to be_an OneboxApiDoc::Param
        expect(param1.name).to eq 'error_status'
        expect(param1.type).to eq 'Integer'
        param2 = params.second
        expect(param2).to be_an OneboxApiDoc::Param
        expect(param2.name).to eq 'error_message'
        expect(param2.type).to eq 'String'
      end
      it "return blank array if the error does not have any param" do
        api = OneboxApiDoc::Api.new(doc_id: @doc.object_id, resource_id: @resource.object_id)
        error = @doc.add_error api, 404, "Not Found"
        params = error.params
        expect(params).to eq []
      end
    end

    describe "permissions" do
      it "return correct permissions array" do
        expected_permissions = [ @doc.add_permission(:permission1), @doc.add_permission(:permission2) ]
        api = OneboxApiDoc::Api.new(doc_id: @doc.object_id, resource_id: @resource.object_id)
        error = @doc.add_error api, 404, "Not Found" do
          permissions :permission1, :permission2
        end
        permissions = error.permissions
        expect(permissions).to be_an Array
        expect(permissions.size).to be > 0 and eq expected_permissions.size
        permission1 = permissions.first
        expect(permission1).to be_an OneboxApiDoc::Permission
        expect(permission1.name).to eq 'permission1'
        permission2 = permissions.second
        expect(permission2).to be_an OneboxApiDoc::Permission
        expect(permission2.name).to eq 'permission2'
      end
      it "return blank array if the error does not have and permissions" do
        api = OneboxApiDoc::Api.new(doc_id: @doc.object_id, resource_id: @resource.object_id)
        error = @doc.add_error api, 404, "Not Found"
        permissions = error.permissions
        expect(permissions).to eq []
      end
    end
  end
end