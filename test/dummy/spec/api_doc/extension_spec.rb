require "rails_helper"

module OneboxApiDoc
  describe Base do
    let(:base) do
      @base = OneboxApiDoc.base
      @base.reload_document
      @base
    end
    let(:doc_v1) { @doc_v1 = OneboxApiDoc.base.get_doc("1.0.0") }
    let(:doc_v2) { @doc_v2 = OneboxApiDoc.base.get_doc("2.0.0") }
    let(:doc_v2_1) { @doc_v2_1 = OneboxApiDoc.base.get_doc("2.1.0") }

    before do
      OneboxApiDoc::Engine.api_doc_paths do |doc|
        doc.path "api_doc/**/*.rb", priority: 0
        doc.path "api_doc_2/**/*.rb", priority: 1
      end
    end
    
    it "can add new api" do
      OneboxApiDoc.base.reload_document
      expect(OneboxApiDoc.base.get_doc("2.1.0").apis.size).to eq 1
      expect(doc_v2_1.apis.size).to eq 1
    end
  end
end