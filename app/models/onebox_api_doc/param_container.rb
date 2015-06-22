module OneboxApiDoc
  class ParamContainer < BaseObject

    attr_accessor :doc_id, :param_ids

    def params
      doc.params.select { |param| self.param_ids.include? param.object_id }
    end

    def doc
      OneboxApiDoc.base.docs.select { |doc| doc.object_id == self.doc_id }.first
    end
    
    private

    def set_default_version
      self.param_ids ||= []
    end
    
  end
end