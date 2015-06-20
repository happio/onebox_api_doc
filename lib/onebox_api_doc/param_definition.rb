module OneboxApiDoc
  class ParamDefinition
    attr_reader :param

    def initialize param, &block
      @param = param
      self.instance_eval(&block) if block_given?
    end

    def param name, type, options={}, &block
      nested_param = OneboxApiDoc.base.add_param(name, type, options)
      ParamDefinition.new(nested_param, &block) if block_given?
    end

    def desc desc
      api.desc = desc
    end

    def tags *tags
      api.tag_ids = tags.map{ |tag| api.doc.add_tag(tag.to_s).object_id }
    end

    def permissions *permissions
      api.permission_ids = permissions.map{ |permission| api.doc.add_permission(permission).object_id }
    end
  end
end
