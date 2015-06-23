module OneboxApiDoc
  class ApiDoc < BaseObject

    attr_accessor :tags, :permissions, :apis, :params, :errors
    attr_accessor :version_id, :resource_id

    # def initialize version_id, resource_id
    #   self.version_id = version_id
    #   self.resource_id = resource_id
    #   self.tags = []
    #   self.permissions = []
    #   self.apis = []
    #   self.params = []
    #   self.errors = []
    # end

    def resource
      @resource ||= OneboxApiDoc.base.resources.detect { |resource| resource.object_id == self.resource_id }
    end

    def version
      @version ||= OneboxApiDoc.base.versions.detect { |version| version.object_id == self.version_id }
    end

    def add_api action, short_desc, &block
      resource_name = self.resource.name
      route = Route.route_for(resource_name, action)
      return false unless route.present?
      url = route[:path]
      method = route[:method]
      unless self.apis.map(&:action).include? action
        api = OneboxApiDoc::Api.new(doc_id: self.object_id, resource_id: self.resource_id, action: action, method: method, url: url, short_desc: short_desc)
        self.apis << api
      else
        api = self.apis.detect { |api| api.action == action }
      end
      OneboxApiDoc::ApiDefinition.new(api, &block) if block_given?
      api
    end

    def add_param name, type, options={}, &block
      options = {doc_id: self.object_id, name: name, type: type}.merge(options)
      param = OneboxApiDoc::Param.new(options, &block)
      self.params << param
      param
    end

    def add_error api, error_status, error_message, &block
      error = OneboxApiDoc::Error.new(doc_id: self.object_id, code: error_status, message: error_message, &block)
      if block_given?
        error_detail = OneboxApiDoc::ApiDefinition::ErrorDefinition.new(api.doc, &block)
        error.param_ids = error_detail.param_ids
        error.permission_ids = error_detail.permission_ids
      end
      self.errors << error
      error
    end

    def add_tag tag_name
      unless self.tags.map(&:name).include? tag_name.to_s
        tag = OneboxApiDoc::Tag.new(name: tag_name)
        tags << tag
        tag
      else
        tags.detect { |tag| tag.name == tag_name }
      end
    end

    def add_permission permission_name
      unless self.permissions.map(&:name).include? permission_name.to_s
        permission = OneboxApiDoc::Permission.new(name: permission_name)
        self.permissions << permission
        permission
      else
        self.permissions.detect { |permission| permission.name == permission_name.to_s }
      end
    end

    def nested_params_of param_id
      self.params.select { |param| param.parent_id == param_id }
    end

    class << self

      cattr_accessor :api_doc

      # attr_accessor :_controller_name, :_version, :_default_version, :_apis
      # # for extension
      # attr_accessor :_extension_name, :_core_versions
      
      def inherited(subclass)
        # subclass._controller_name = subclass.name.demodulize.gsub(/ApiDoc/,"").pluralize.underscore
        # subclass._version = OneboxApiDoc.base.default_version
        # subclass._core_versions = []

        resource_name = subclass.name.demodulize.gsub(/ApiDoc/,"").pluralize.underscore
        resource = OneboxApiDoc.base.add_resource(resource_name)
        version = OneboxApiDoc.base.default_version
        self.api_doc = OneboxApiDoc.base.add_doc(subclass, version.object_id, resource.object_id)
      end

      ##############################
      ####### Setter Methods #######
      ##############################

      # def controller_name name
      #   @_controller_name = name.to_s
      # end
      def controller_name name
        self.api_doc.resource_id = OneboxApiDoc.base.add_resource(name).object_id
      end

      # for extension
      # def extension_name name
      #   @_extension_name = name.to_s
      # end

      # core_version is for extension
      # def version version, core_version: {}
      #   if core_version.blank?
      #     @_version = OneboxApiDoc.base.add_version version.to_s
      #   elsif @_extension_name.present?
      #     @_version = OneboxApiDoc.base.add_extension_version @_extension_name, version.to_s
      #     set_core_versions core_version
      #   end
      # end

      # core_version is for extension
      def version name, core_version: {}
        if core_version.blank?
          self.api_doc.version_id = OneboxApiDoc.base.add_version(name).object_id
        else
          self.api_doc.version_id = OneboxApiDoc.base.add_extension_version(name).object_id
        end
      end

      # def api action, short_desc="", &block
      #   @_apis ||= []
      #   api = OneboxApiDoc::Api.new(_controller_name, action, short_desc, &block)
      #   @_apis << api
      #   @_version.apis << api
      #   OneboxApiDoc.base.add_api api
      # end
      def api action, short_desc="", &block
        self.api_doc.add_api action, short_desc, &block
      end

      # def def_param_group name, &block
      #   OneboxApiDoc.base.add_param_group name, &block
      # end

      # def set_core_versions core_version
      #   # all_core_versions = OneboxApiDoc.base.core_versions
      #   # ...
      #   # TODO: set core version incase of this is extension api doc
      # end

    end

    private

    def set_default_value
      self.tags = []
      self.permissions = []
      self.apis = []
      self.params = []
      self.errors = []
    end

  end
end