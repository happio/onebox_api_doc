module OneboxApiDoc
  class Param < ParamContainer

    @_name
    @_type
    @_desc
    @_permissions
    @_required
    @_default_value
    @_warning
    @_validates
    @_params

    def initialize name="", type, desc: "", permissions: [], required: false,
      default: nil, validates: {}, warning: nil, &block
      @_name = name.to_s
      @_type = type.to_s.capitalize
      @_desc = desc
      @_required = required
      @_default_value = default
      @_warning = warning
      @_permissions = permissions
      @_validates = validation_messages validates
      @_params = []
      self.instance_eval(&block) if block_given?
    end

    ##############################
    ####### Getter Methods #######
    ##############################

    def _name
      @_name
    end

    def _type
      @_type
    end

    def _desc
      @_desc
    end

    def _permissions
      @_permissions
    end

    def _required
      @_required
    end

    def _default_value
      @_default_value
    end

    def _warning
      @_warning
    end

    def _validates
      @_validates
    end

    def _params
      @_params
    end

  end
end