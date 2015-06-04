module OneboxApiDoc
  class Param < ParamContainer

    attr_reader :_name, :_type, :_desc, :_permissions, :_required, 
    :_default_value, :_warning, :_validates, :_params

    def initialize name, type, options={}, &block
      @_name = name.to_s
      @_type = type.to_s.capitalize
      @_desc = options[:desc]
      @_required = options[:required]
      @_default_value = options[:default]
      @_warning = options[:warning]
      if options[:permissions].present?
        permissions = options[:permissions]
        permissions = [permissions] unless permissions.is_a? Array
        @_permissions = permissions.map{ |permission| OneboxApiDoc.base.add_permission permission }
      end
      @_validates = validation_messages(options[:validates] || {})
      @_params = []
      self.instance_eval(&block) if block_given?
    end

  end
end