require "rails_helper"

module OneboxApiDoc
  describe ParamContainer do
    before do
      @base = OneboxApiDoc.base
      @doc = @base.add_doc @base.default_version.object_id
    end

    describe "initialize" do
      it "set correct attributes" do
        param_container = OneboxApiDoc::ParamContainer.new doc_id: @doc.object_id, param_ids: [1,2,3]
        expect(param_container).not_to eq nil
        expect(param_container.doc).to eq @doc
        expect(param_container.param_ids).to eq [1,2,3]
      end

      it 'set default value' do
        param_container = OneboxApiDoc::ParamContainer.new doc_id: @doc.object_id
        expect(param_container.param_ids).to eq []
      end
    end
  end
end