module OneboxApiDoc
  class Param < BaseObject

    # attr_reader :_name, :_type, :_desc, :_permissions, :_required, 
    # :_default_value, :_warning, :_validates, :_params

    # def initialize name, type, options={}, &block
    #   @_name = name.to_s
    #   @_type = type.to_s.capitalize
    #   @_desc = options[:desc]
    #   @_required = options[:required]
    #   @_default_value = options[:default]
    #   @_warning = options[:warning]
    #   if options[:permissions].present?
    #     permissions = options[:permissions]
    #     permissions = [permissions] unless permissions.is_a? Array
    #     @_permissions = permissions.map{ |permission| OneboxApiDoc.base.add_permission permission }
    #   end
    #   @_validates = validation_messages(options[:validates] || {})
    #   @_params = []
    #   self.instance_eval(&block) if block_given?
    # end

    # def param name="", type, options, &block
    #   @_params << OneboxApiDoc::Param.new(name, type, options, &block)
    # end

    # def param_group name
    #   block = OneboxApiDoc.base.get_param_group(name)
    #   self.instance_exec(&block)
    # end

    attr_accessor :doc_id, :name, :type, :desc, :required, :default, :warning, 
      :validates, :permission_ids, :from_version_id, :parent_id
      # from_version_id is for when extension add param to specific api

    def initialize *attrs, &block
      super(*attrs)
      OneboxApiDoc::ApiDefinition::ParamContainerDefinition.new(self, &block) if block_given?
    end

    def params
      OneboxApiDoc.base.nested_params_of(self.object_id)
    end

    def doc
      OneboxApiDoc.base.docs.select { |doc| doc.object_id == self.doc_id }.first
    end

    def parent
      self.doc.params.select { |param| param.object_id == self.parent_id }.first
    end

    def permissions
      self.doc.permissions.select { |permission| self.permission_ids.include? permission.object_id }
    end

    def permissions=(permission_names)
      self.permission_ids = permission_names.map { |permission_name| self.doc.add_permission(name: permission_name) }
    end

    private

    def set_default_value
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
          "must be within #{value.to_s}"
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