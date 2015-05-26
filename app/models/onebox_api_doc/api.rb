module OneboxApiDoc
  class Api

    @_action
    @_method
    @_url
    @_permissions
    @_short_desc
    @_desc
    @_tags
    @_header
    @_body
    @_response
    @_error

    def initialize controller_name, action, short_desc="", &block
      @_url = ApiDoc.url_for(controller_name, action)
      @_method = ApiDoc.method_for(controller_name, action)
      @_action = action.to_s
      @_short_desc = short_desc
      @_permissions = []
      @_tags = []
      @_header = []
      @_body = []
      @_response = []
      @_error = []
      self.instance_eval(&block) if block_given?
    end

    ##############################
    ####### Getter Methods #######
    ##############################

    def _url
      @_url
    end

    def _action
      @_action
    end

    def _method
      @_method
    end

    def _short_desc
      @_short_desc
    end

    def _desc
      @_desc
    end

    def _tags
      @_tags
    end

    def _permissions
      @_permissions
    end

    def _header
      @_header
    end

    def _body
      @_body
    end

    def _response
      @_response
    end

    def _error
      @_error
    end

    ##############################
    ####### Setter Methods #######
    ##############################

    def desc desc
      @_desc = desc
    end

    def tags *tags
      @_tags = tags
    end

    def permissions *permissions
      @_permissions = permissions
    end

    def header &block
      @_header = Header.new(&block) if block_given?
    end

    def body &block
      @_body = Body.new(&block) if block_given?
    end

    def response &block
      @_response = Response.new(&block) if block_given?
    end

    def error &block
      @_error = Error.new(&block) if block_given?
    end

    ##############################
    ####### Nested Classes #######
    ##############################

    class Header < ParamContainer
      @_params
    end

    class Body < ParamContainer
      @_params
    end

    class Response < ParamContainer
      @_params
    end

    class Error
      @_codes

      def _codes
        @codes
      end
      
      def code error_code, message="", &block
        @_codes ||= []
        @_codes << Code.new(error_code, message, &block)
      end

      class Code < ParamContainer
        @_params
        @_code
        @_message
        @_permissions

        def initialize code, message, &block
          @_code = code
          @_message = message
          @_params = []
          @_permissions = []
          self.instance_eval(&block) if block_given?
        end

        ##############################
        ####### Getter Methods #######
        ##############################

        def _code
          @_code
        end

        def _message
          @_message
        end

        def _permissions
          @_permissions
        end

        ##############################
        ####### Setter Methods #######
        ##############################

        def permissions *permissions
          @_permissions = permissions
        end

        def param name="", type, desc: "", permissions: [], &block
          @_params << OneboxApiDoc::Param.new(name, type, desc, permissions, &block)
        end
      end
    end
  end
end