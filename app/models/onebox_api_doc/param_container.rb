module OneboxApiDoc
  class ParamContainer

    def initialize &block
      @_params = []
      self.instance_eval(&block) if block_given?
    end

    def param name="", type, desc: "", permissions: [], required: false,
      default: nil, validates: {}, warning: nil, &block
      @_params << OneboxApiDoc::Param.new(name, type)
    end

  end
end