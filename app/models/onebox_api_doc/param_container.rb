module OneboxApiDoc
  class ParamContainer

    attr_reader :_params, :_api

    def initialize api = nil, &block
      @_params = []
      @_api = api
      self.instance_eval(&block) if block_given?
    end

    ##############################
    ####### Setter Methods #######
    ##############################

    def param name="", type, options, &block
      @_params << OneboxApiDoc::Param.new(name, type, options, &block)
    end

    def param_group name
      block = OneboxApiDoc.base.get_param_group(self._api._api_doc, name)
      self.instance_exec(&block)
    end

    ##############################
    ####### Helper Methods #######
    ##############################

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