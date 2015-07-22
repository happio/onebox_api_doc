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
      api.tag_ids = tags.map{ |tag| api.doc.get_tag(tag.to_sym).object_id }
    end

    def permissions *permissions
      api.permission_ids = permissions.map{ |permission| api.doc.get_permission(permission).object_id }
    end

    def request &block
      if block_given?
        request = RequestResponseDefinition.new(:request, api, &block)
      end
    end

    def response &block
      if block_given?
        response = RequestResponseDefinition.new(:response, api, &block)
      end
    end

    def error &block
      if block_given?
        errors = ErrorContainerDefinition.new(api, &block)
      end
    end

    def warning warning
      api.warning = warning
    end

    class RequestResponseDefinition
      attr_reader :mapper
      attr_reader :api

      def initialize _mapper, api=nil, &block
        @mapper = _mapper
        @api = api
        self.instance_eval(&block) if block_given?
      end

      def header &block
        if block_given?
          params = ParamContainerDefinition.new("#{mapper}/header", api.doc, api.object_id, &block)
        end
      end

      def body &block
        if block_given?
          params = ParamContainerDefinition.new("#{mapper}/body", api.doc, api.object_id, &block)
        end
      end
    end

    class ParamContainerDefinition
      attr_reader :mapper
      attr_reader :api_id, :doc, :parent_id

      def initialize _mapper, _doc, _api_id, _parent_id=nil, &block
        @mapper = _mapper.to_s
        @doc = _doc
        @api_id = _api_id
        @parent_id = _parent_id
        @param_ids = []
        self.instance_eval(&block) if block_given?
      end

      def param name, type, options={}, &block
        options[:mapper] = mapper
        options[:api_id] = api_id
        options[:parent_id] = parent_id if parent_id.present?
        if options[:permissions].present? and doc.present?
          options[:permissions] = [options[:permissions]] unless options[:permissions].is_a? Array
          options[:permission_ids] = options[:permissions].map { |permission_slug| doc.get_permission(permission_slug).object_id }
        end
        param = self.doc.add_param(name, type, options, &block)
        self.doc.add_annoucement(:param, doc_id: doc.object_id, param_id: param.object_id) if param.warning
        @param_ids << param.object_id unless self.parent_id.present?
      end

      def param_group name
        block = self.doc.get_param_group(name)
        self.instance_exec(&block)
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
      end

      def error_group name
        block = self.api.doc.get_error_group(name)
        self.instance_exec(&block)
      end
    end

    class ErrorDefinition < ParamContainerDefinition
      attr_reader :permission_ids

      def initialize _mapper, _doc, _api_id, _parent_id=nil, &block
        @permission_ids = []
        super
      end

      def permissions *permissions
        @permission_ids = permissions.map{ |permission| doc.get_permission(permission).object_id }
      end


    end

  end
end
