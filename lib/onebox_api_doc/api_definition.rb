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
        api.request.header.param_ids = request.header_param_ids
        api.request.body.param_ids = request.body_param_ids
      end
    end

    def response &block
      if block_given?
        response = RequestResponseDefinition.new(api, &block)
        api.response.header.param_ids = response.header_param_ids
        api.response.body.param_ids = response.body_param_ids
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
          params = ParamContainerDefinition.new(self.api.doc, &block)
          @header_param_ids = params.param_ids
        end
      end

      def body &block
        if block_given?
          params = ParamContainerDefinition.new(self.api.doc, &block)
          @body_param_ids = params.param_ids
        end
      end
    end

    class ParamContainerDefinition
      attr_reader :doc, :parent_id, :param_ids

      def initialize doc, _parent_id=nil, &block
        @doc = doc
        @parent_id = _parent_id
        @param_ids = []
        self.instance_eval(&block) if block_given?
      end

      def param name, type, options={}, &block
        options[:parent_id] = self.parent_id if self.parent_id.present?
        if options[:permissions].present? and self.doc.present?
          options[:permission_ids] = options[:permissions].map { |permission_name| self.doc.add_permission(permission_name).object_id }
        end
        param = self.doc.add_param(name, type, options, &block)
        @param_ids << param.object_id unless self.parent_id.present?
      end

      # def param_group name
      #   block = OneboxApiDoc.base.get_param_group(name)
      #   self.instance_exec(&block)
      # end
    end

    class ErrorContainerDefinition
      attr_reader :api

      def initialize api, &block
        @api = api
        self.instance_eval(&block) if block_given?
      end

      def code error_status, error_message="", &block
        error = self.api.doc.add_error(api, error_status, error_message, &block)
      end
    end

    class ErrorDefinition < ParamContainerDefinition
      attr_reader :permission_ids

      def initialize doc, &block
        @permission_ids = []
        super
      end

      def permissions *permissions
        @permission_ids = permissions.map{ |permission| doc.add_permission(permission).object_id }
      end


    end

  end
end
