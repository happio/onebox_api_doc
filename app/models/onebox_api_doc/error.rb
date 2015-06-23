module OneboxApiDoc
  class Error < BaseObject
    
    attr_accessor :doc_id, :code, :message, :permission_ids, :param_ids

    def doc
      @doc ||= OneboxApiDoc.base.docs.detect { |doc| doc.object_id == self.doc_id }
    end

    def params
      @params ||= self.doc.params.select { |param| self.param_ids.include? param.object_id }
    end

    def permissions
      @permissions ||= self.doc.permissions.select { |permission| self.permission_ids.include? permission.object_id }
    end

    def permissions=(permission_names)
      self.permission_ids = permission_names.map { |permission_name| self.doc.add_permission(name: permission_name) }
    end

    private

    def set_default_value
      self.permission_ids ||= []
      self.param_ids ||= []
    end
  end
end