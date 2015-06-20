module OneboxApiDoc
  class ApiDefinition
    attr_reader :api

    def initialize api, &block
      @api = api
      self.instance_eval(&block) if block_given?
    end

    def desc desc
      api.desc = desc
    end

    def tags *tags
      api.tag_ids = tags.map{ |tag| api.doc.add_tag(tag.to_s).object_id }
    end

    def permissions *permissions
      api.permission_ids = permissions.map{ |permission| api.doc.add_permission(permission).object_id }
    end

    def request &block
      if block_given?
        request = RequestResponseDefinition.new(&block)
        api.request[:header] = request.header_param_ids
        api.request[:body] = request.body_param_ids
      end
    end

    def response &block
      if block_given?
        response = RequestResponseDefinition.new(&block)
        api.response[:header] = response.header_param_ids
        api.response[:body] = response.body_param_ids
      end
    end

    class RequestResponseDefinition
      attr_reader :header_param_ids, :body_param_ids

      def initialize &block
        @header_param_ids = []
        @body_param_ids = []
        self.instance_eval(&block) if block_given?
      end

      def header &block
        if block_given?
          params = ParamContainerDefinition.new(&block)
          @header_param_ids = params.param_ids
        end
      end

      def body &block
        if block_given?
          params = ParamContainerDefinition.new(&block)
          @body_param_ids = params.param_ids
        end
      end
    end

    class ParamContainerDefinition
      attr_reader :parent_param, :param_ids

      def initialize parent_param=nil, &block
        @parent_param = parent_param
        @param_ids = []
        self.instance_eval(&block) if block_given?
      end

      def param name, type, options={}, &block
        options[:parent_id] = self.parent_param.object_id if self.parent_param.present?
        param = OneboxApiDoc.base.add_param(name, type, options, &block)
        @param_ids << param.object_id
      end
    end

    def error &block
      # @_error = Error.new(&block) if block_given?
    end

  end
end
