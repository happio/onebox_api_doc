require "rails_helper"

module OneboxApiDoc
  describe ParamContainer do
    before do
      @base = OneboxApiDoc.base
      @doc = @base.add_doc @base.default_version.object_id
    end

    describe "initialize" do
      it "set correct attributes" do
        param_container = OneboxApiDoc::ParamContainer.new(doc_id: @doc.object_id, mapper: 'request/body', api_id: 555)
        expect(param_container).not_to eq nil
        expect(param_container.doc).to eq @doc
        expect(param_container.mapper).to eq 'request/body'
        expect(param_container.api_id).to eq 555
      end
    end
  end
end