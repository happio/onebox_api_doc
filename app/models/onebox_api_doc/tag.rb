module OneboxApiDoc
  class Tag < BaseObject

    attr_accessor :slug, :name, :doc_id, :default

    def doc
      @doc ||= OneboxApiDoc.base.docs.detect { |doc| doc.object_id == self.doc_id }
    end

    def apis
      doc.apis.select { |api| api.tag_ids.include? self.object_id }
    end

    def apis_group_by_resource
      result = {}
      self.apis.each do |api|
        result[api.resource.name] ||= []
        result[api.resource.name] << api
      end
      result
    end

    private

    def set_default_value
      self.default ||= false
    end
    
  end
end