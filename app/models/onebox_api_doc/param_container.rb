module OneboxApiDoc
  class ParamContainer < BaseObject

    attr_accessor :doc_id
    attr_accessor :mapper, :api_id

    # @return root params only
    def params 
      @params ||= doc.params.select do |param|
        param.mapper == mapper and param.api_id == api_id and param.root?
      end
    end

    def doc
      @doc ||= OneboxApiDoc.base.docs.detect { |doc| doc.object_id == self.doc_id }
    end
    
    private

    def set_default_value
      @params = nil
      @doc = nil
    end
    
  end
end