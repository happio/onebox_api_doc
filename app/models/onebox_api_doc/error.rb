module OneboxApiDoc
  class Error < BaseObject
    
    attr_accessor :api_id, :doc_id, :code, :message, :permission_ids, :param_ids

    def doc
      @doc ||= OneboxApiDoc.base.docs.detect { |doc| doc.object_id == doc_id }
    end

    def api
      @api ||= doc.apis.detect { |api| api.object_id == api_id }
    end

    def params
      @params ||= doc.params.select { |param| param.mapper == 'error' and param.api == api }
    end

    def permissions
      @permissions ||= doc.permissions.select { |permission| permission_ids.include? permission.object_id }
    end

    private

    def set_default_value
      @doc = nil
      @params = nil
      @permissions = nil
      self.permission_ids ||= []
      self.param_ids ||= []
    end
  end
end