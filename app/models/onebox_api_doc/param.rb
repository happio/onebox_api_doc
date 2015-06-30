module OneboxApiDoc
  class Param < BaseObject

    attr_accessor :doc_id, :name, :type, :desc, :required, :default, :warning, 
      :validates, :permission_ids, :from_version_id, :parent_id, :api_id
      # from_version_id is for when extension add param to specific api

    def initialize *attrs, &block
      super
      OneboxApiDoc::ApiDefinition::ParamContainerDefinition.new(self.api, self.object_id, &block) if block_given?
    end

    def api
      @api ||= doc.apis.detect { |api| api.object_id == self.api_id }
    end

    def params
      @params ||= doc.nested_params_of(self.object_id)
    end

    def doc
      @doc ||= OneboxApiDoc.base.docs.detect { |doc| doc.object_id == self.doc_id }
    end

    def parent
      @parent ||= self.doc.params.detect { |param| param.object_id == self.parent_id }
    end

    def permissions
      @permissions ||= self.doc.permissions.select { |permission| self.permission_ids.include? permission.object_id }
    end

    def permissions=(permission_names)
      self.permission_ids = permission_names.map { |permission_name| doc.add_permission(permission_name.to_s).object_id }
      permissions
    end

    private

    def set_default_value
      @params = nil
      @doc = nil
      @parent = nil
      @permissions = nil
      self.permission_ids ||= []
      self.validates = validation_messages(self.validates || {})
      self.type = self.type.capitalize
    end

    def validation_messages validates={}
      validates.map do |key, value|
        case key
        when :min
          "cannot be less than #{value}"
        when :max
          "cannot be more than #{value}"
        when :within
          "must be within #{value.map(&:to_s)}"
        when :pattern
          "must match format #{value}"
        when :email
          value ? "must be in email format" : next
        when :min_length
          "cannot have length less than #{value}"
        when :max_length
          "cannot have length more than #{value}"
        end
      end.compact
    end

  end
end