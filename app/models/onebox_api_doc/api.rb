module OneboxApiDoc
  class Api < BaseObject

    attr_accessor :resource_id, :version_id, :doc_id
    attr_accessor :action, :method, :url, :permission_ids, :desc, :short_desc, :tag_ids, :error_ids
    attr_accessor :request
    attr_accessor :response

    def doc
      @doc ||= OneboxApiDoc.base.docs.detect { |doc| doc.object_id == self.doc_id }
    end

    def resource
      @resource ||= OneboxApiDoc.base.resources.detect { |resource| resource.object_id == self.resource_id }
    end

    def version
      @version ||= doc.version
    end

    def tags
      @tags ||= doc.tags.select { |tag| self.tag_ids.include? tag.object_id }
    end

    def permissions
      @permissions ||= doc.permissions.select { |permission| self.permission_ids.include? permission.object_id }
    end

    def errors
      @errors ||= doc.errors.select { |error| self.error_ids.include? error.object_id }
    end

    def is_extension?
      version.is_extension?
    end

    private

    def set_default_value
      self.version_id = doc.version_id
      self.method = self.method.upcase if self.method.present?
      self.permission_ids ||= []
      self.tag_ids ||= []
      self.error_ids ||= []
      self.request ||= OpenStruct.new(
        header: ParamContainer.new(doc_id: doc_id), 
        body: ParamContainer.new(doc_id: doc_id))
      self.response ||= OpenStruct.new(
        header: ParamContainer.new(doc_id: doc_id), 
        body: ParamContainer.new(doc_id: doc_id))
    end

  end
end