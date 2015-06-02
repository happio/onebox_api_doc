module OneboxApiDoc
  class Param < ParamContainer

    attr_reader :_name, :_type, :_desc, :_permissions, :_required, 
    :_default_value, :_warning, :_validates, :_params

    def initialize name, type, options={}, &block
    # def initialize name="", type, desc: "", permissions: [], required: false,
    #   default: nil, validates: {}, warning: nil, &block
      @_name = name.to_s
      @_type = type.to_s.capitalize
      @_desc = options[:desc]
      @_required = options[:required]
      @_default_value = options[:default]
      @_warning = options[:warning]
      @_permissions = options[:permissions]
      @_validates = validation_messages(options[:validates] || {})
      @_params = []
      self.instance_eval(&block) if block_given?
    end

  end
end