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
        request = RequestResponseDefinition.new(api, &block)
        api.request[:header] = request.header_param_ids
        api.request[:body] = request.body_param_ids
      end
    end

    def response &block
      if block_given?
        response = RequestResponseDefinition.new(api, &block)
        api.response[:header] = response.header_param_ids
        api.response[:body] = response.body_param_ids
      end
    end

    def error &block
      if block_given?
        errors = ErrorContainerDefinition.new(api, &block)
      end
    end

    class RequestResponseDefinition
      attr_reader :api, :header_param_ids, :body_param_ids

      def initialize api=nil, &block
        @api = api
        @header_param_ids = []
        @body_param_ids = []
        self.instance_eval(&block) if block_given?
      end

      def header &block
        if block_given?
          params = ParamContainerDefinition.new(api, &block)
          @header_param_ids = params.param_ids
        end
      end

      def body &block
        if block_given?
          params = ParamContainerDefinition.new(api, &block)
          @body_param_ids = params.param_ids
        end
      end
    end

    class ParamContainerDefinition
      attr_reader :parent_object, :param_ids

      def initialize parent_object=nil, &block
        @parent_object = parent_object
        @param_ids = []
        self.instance_eval(&block) if block_given?
      end

      def param name, type, options={}, &block
        options[:parent_id] = self.parent_object.object_id if self.parent_object.is_a? OneboxApiDoc::Param
        if options[:permissions].present? and self.parent_object.doc.present?
          options[:permission_ids] = options[:permissions].map { |permission_name| self.parent_object.doc.add_permission(permission_name).object_id }
        end
        param = self.parent_object.doc.add_param(name, type, options, &block)
        @param_ids << param.object_id
      end
    end

    class ErrorContainerDefinition
      attr_reader :api

      def initialize api, &block
        @api = api
        self.instance_eval(&block) if block_given?
      end

      def code error_status, error_message="", &block
        error = self.api.doc.add_error(api, error_status, error_message, &block)
        api.error_ids << error.object_id
      end
    end

    class ErrorDefinition < ParamContainerDefinition
      attr_reader :permission_ids

      def initialize parent_object, &block
        @permission_ids = []
        super
      end

      def permissions *permissions
        @permission_ids = permissions.map{ |permission| parent_object.doc.add_permission(permission).object_id }
      end


    end

  end
end
