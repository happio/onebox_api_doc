module OneboxApiDoc
  class Param

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

    attr_accessor :name, :type, :desc, :required, :default_value, :warning, 
      :validates, :permission_ids, :from_version_id, :parent_id
      # from_version_id is for when extension add param to specific api

    def initialize name, type, options={}, &block
      self.name = name.to_s
      self.type = type.to_s.capitalize
      self.desc = options[:desc]
      self.parent_id = options[:parent_id]
      self.required = options[:required]
      self.default_value = options[:default]
      self.warning = options[:warning]
      self.from_version_id = options[:from_version_id]
      self.permission_ids = options[:permission_ids]
      self.validates = validation_messages(options[:validates] || {})
      OneboxApiDoc::ApiDefinition::ParamContainerDefinition.new(self, &block) if block_given?
    end

    def params
      OneboxApiDoc.base.nested_params_of(self.object_id)
    end

    private

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