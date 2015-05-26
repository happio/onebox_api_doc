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
      @_name = name
      @_type = type
      @_desc = desc
      @_required = required
      @_default_value = default
      @_warning = warning
      @_permissions = permissions
      @_validates = validates
      @_params = []
      self.instance_eval(&block) if block_given?
    end

    private

    # def validates options={}
    # end

  end
end