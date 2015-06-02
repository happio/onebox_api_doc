module OneboxApiDoc
  class ParamContainer

    def initialize &block
      @_params = []
      self.instance_eval(&block) if block_given?
    end

    ##############################
    ####### Setter Methods #######
    ##############################

    def param name="", type, options, &block
      @_params << OneboxApiDoc::Param.new(name, type, options, &block)
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