module OneboxApiDoc
  class Api < BaseObject

    # attr_reader :_controller_name, :_action, :_method, :_url, :_permissions, :_short_desc,
    #   :_desc, :_tags, :_header, :_body, :_response, :_error, :_api_doc

    attr_accessor :resource_id, :version_id, :doc_id
    attr_accessor :action, :method, :url, :permission_ids, :desc, :short_desc, :tag_ids, :error_ids
    attr_accessor :request
    attr_accessor :response

    def doc
      @doc ||= OneboxApiDoc.base.docs.detect { |doc| doc.object_id == self.doc_id }
    end

    def resource
      @resource ||= doc.resource
    end

    def version
      @version ||= doc.version
    end

    def tags
      doc.tags.select { |tag| self.tag_ids.include? tag.object_id }
    end

    def permissions
      doc.permissions.select { |permission| self.permission_ids.include? permission.object_id }
    end

    def errors
      doc.errors.select { |error| self.error_ids.include? error.object_id }
    end

    def is_extension?
      version.is_extension?
    end

    private

    def set_default_value
      self.version_id = doc.version_id
      self.resource_id = doc.resource_id
      self.method = self.method.upcase if self.method.present?
      self.permission_ids ||= []
      self.tag_ids ||= []
      self.error_ids ||= []
      self.request ||= OpenStruct.new(
        header: ParamContainer.new(doc_id: doc_id), 
        body: ParamContainer.new(doc_id: doc_id))
      self.response ||= OpenStruct.new(
        header: ParamContainer.new(doc_id: doc_id), 
        body: ParamContainer.new(doc_id: doc_id))
    end

    # ##############################
    # ####### Setter Methods #######
    # ##############################

    # def desc desc
    #   @_desc = desc
    # end

    # def tags *tags
    #   @_tags = tags.map do |tag|
    #     t = OneboxApiDoc.base.add_tag(tag.to_s)
    #     t.apis << self
    #     t
    #   end
    # end

    # def permissions *permissions
    #   @_permissions = permissions.map{ |permission| OneboxApiDoc.base.add_permission permission }
    # end

    # def header &block
    #   @_header = Header.new(&block) if block_given?
    # end

    # def body &block
    #   @_body = Body.new(&block) if block_given?
    # end

    # def response &block
    #   @_response = Response.new(&block) if block_given?
    # end

    # def error &block
    #   @_error = Error.new(&block) if block_given?
    # end

    # ##############################
    # ####### Nested Classes #######
    # ##############################

    # class Header < ParamContainer
    # end

    # class Body < ParamContainer
    # end

    # class Response < ParamContainer
    # end

    # class Error
    #   attr_reader :_codes

    #   def initialize &block
    #     @_codes ||= []
    #     self.instance_eval(&block) if block_given?
    #   end

    #   def code error_code, message="", &block
    #     @_codes << Code.new(error_code, message, &block)
    #   end

    #   class Code < ParamContainer
    #     attr_reader :_code, :_message, :_permissions

    #     def initialize code, message, &block
    #       @_code = code
    #       @_message = message
    #       @_params = []
    #       @_permissions = []
    #       self.instance_eval(&block) if block_given?
    #     end

    #     ##############################
    #     ####### Setter Methods #######
    #     ##############################

    #     def permissions *permissions
    #       @_permissions = permissions.map{ |permission| OneboxApiDoc.base.add_permission permission }
    #     end

    #     def param name="", type, desc: "", permissions: [], &block
    #       @_params << OneboxApiDoc::Param.new(name, type, desc: desc, permissions: permissions, &block)
    #     end
    #   end
    # end
  end
end