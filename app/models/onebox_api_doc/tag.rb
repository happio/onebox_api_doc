module OneboxApiDoc
  class Tag < BaseObject

    attr_accessor :name, :doc_id

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
    
  end
end