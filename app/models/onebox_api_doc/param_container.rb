module OneboxApiDoc
  class ParamContainer < BaseObject

    attr_accessor :doc_id, :param_ids

    def params
      @params ||= doc.params.select { |param| self.param_ids.include? param.object_id }
    end

    def doc
      @doc ||= OneboxApiDoc.base.docs.detect { |doc| doc.object_id == self.doc_id }
    end
    
    private

    def set_default_version
      @params = nil
      @doc = nil
      self.param_ids ||= []
    end
    
  end
end