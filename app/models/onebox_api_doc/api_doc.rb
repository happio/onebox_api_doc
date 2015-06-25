module OneboxApiDoc
  class ApiDoc < BaseObject

    # attr_accessor :tags, :permissions, :apis, :params, :errors, :param_groups
    # attr_accessor :version_id, :resource_id, :extension_name

    #####################
    ### Class Methods ###
    #####################
    class << self

      cattr_accessor :doc, :resource_id
      
      def inherited(subclass)
        resource_name = subclass.name.demodulize.gsub(/ApiDoc/,"").pluralize.underscore
        resource = OneboxApiDoc.base.add_resource(resource_name)
        self.resource_id = resource.object_id
        version = OneboxApiDoc.base.default_version
        self.doc = OneboxApiDoc.base.add_doc(version.object_id)
      end

      ##############################
      ####### Setter Methods #######
      ##############################

      def controller_name name
        self.resource_id = OneboxApiDoc.base.add_resource(name).object_id
      end

      # for extension
      def extension_name extension_name
        self.doc.extension_name = extension_name.to_s
      end

      # core_version is for extension
      def version version_name, core_version: {}
        if core_version.blank?
          self.doc.version_id = OneboxApiDoc.base.add_version(version_name).object_id
        else
          self.doc.version_id = OneboxApiDoc.base.add_extension_version(version_name, self.doc.extension_name).object_id
        end
      end

      def api action, short_desc="", &block
        self.doc.add_api(self.resource_id, action, short_desc, &block)
      end

      def def_param_group name, &block
        self.doc.add_param_group name, &block
      end

      # def set_core_versions core_version
      #   # all_core_versions = OneboxApiDoc.base.core_versions
      #   # ...
      #   # TODO: set core version incase of this is extension api doc
      # end

    end

    # ########################
    # ### Instance Methods ###
    # ########################

    # def resource
    #   @resource ||= OneboxApiDoc.base.resources.detect { |resource| resource.object_id == self.resource_id }
    # end

    # def version
    #   @version ||= OneboxApiDoc.base.versions.detect { |version| version.object_id == self.version_id }
    # end

    # def app
    #   version.app
    # end

    # def get_apis action=nil
    #   if action.present?
    #     self.apis.detect { |api| api.action == action.to_s }
    #   else
    #     self.apis
    #   end
    # end

    # def add_api action, short_desc, &block
    #   resource_name = self.resource.name
    #   route = Route.route_for(resource_name, action)
    #   return false unless route.present?
    #   url = route[:path]
    #   method = route[:method]
    #   unless self.apis.map(&:action).include? action
    #     api = OneboxApiDoc::Api.new(doc_id: self.object_id, resource_id: self.resource_id, action: action, method: method, url: url, short_desc: short_desc)
    #     self.apis << api
    #   else
    #     api = self.apis.detect { |api| api.action == action }
    #   end
    #   OneboxApiDoc::ApiDefinition.new(api, &block) if block_given?
    #   api
    # end

    # def add_param name, type, options={}, &block
    #   options = {doc_id: self.object_id, name: name, type: type}.merge(options)
    #   param = OneboxApiDoc::Param.new(options, &block)
    #   self.params << param
    #   param
    # end

    # def add_error api, error_status, error_message, &block
    #   error = OneboxApiDoc::Error.new(doc_id: self.object_id, code: error_status, message: error_message, &block)
    #   api.error_ids << error.object_id
    #   if block_given?
    #     error_detail = OneboxApiDoc::ApiDefinition::ErrorDefinition.new(api.doc, &block)
    #     error.param_ids = error_detail.param_ids
    #     error.permission_ids = error_detail.permission_ids
    #   end
    #   self.errors << error
    #   error
    # end

    # def add_tag tag_name
    #   tag_name = tag_name.to_s
    #   tag = tags.detect { |tag| tag.name == tag_name }
    #   unless tag.present?
    #     tag = OneboxApiDoc::Tag.new(name: tag_name)
    #     tags << tag
    #     tag
    #   else
    #     tag
    #   end
    # end

    # def add_permission permission_name
    #   permission_name = permission_name.to_s
    #   permission = self.permissions.detect { |permission| permission.name == permission_name }
    #   unless permission.present?
    #     permission = OneboxApiDoc::Permission.new(name: permission_name)
    #     self.permissions << permission
    #     permission
    #   else
    #     permission
    #   end
    # end

    # # Params Group methods
    # def add_param_group(name, &block)
    #   key = name.to_s
    #   self.param_groups[key] = block
    # end

    # def get_param_group(name)
    #   key = name.to_s
    #   if self.param_groups.has_key?(key)
    #     return self.param_groups[key]
    #   else
    #     raise "param group #{key} not defined"
    #   end
    # end

    # def nested_params_of param_id
    #   self.params.select { |param| param.parent_id == param_id }
    # end

    # private

    # def set_default_value
    #   self.tags = []
    #   self.permissions = []
    #   self.apis = []
    #   self.params = []
    #   self.errors = []
    #   self.param_groups = {}
    # end

  end
end