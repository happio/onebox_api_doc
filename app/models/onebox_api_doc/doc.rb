module OneboxApiDoc
  class Doc < BaseObject

    attr_accessor :tags, :permissions, :apis, :params, :errors, :param_groups
    attr_accessor :version_id, :extension_name, :resource_ids

    ########################
    ### Instance Methods ###
    ########################

    def resources
      @resources ||= OneboxApiDoc.base.resources.select { |resource| self.resource_ids.include? resource.object_id }
    end

    def version
      @version ||= OneboxApiDoc.base.versions.detect { |version| version.object_id == self.version_id }
    end

    def app
      version.app
    end

    def apis_group_by_resource
      result = {}
      unless @apis_group_by_resource.present?
        self.apis.each do |api|
          result[api.resource.name] ||= []
          result[api.resource.name] << api
        end
      end
      @apis_group_by_resource ||= result
    end

    def get_apis resource_name, action=nil
      resource = OneboxApiDoc.base.get_resource resource_name
      if resource.present? and action.present?
        self.apis.detect { |api| api.resource_id == resource.object_id and api.action == action.to_s }
      elsif resource.present?
        self.apis.select { |api| api.resource_id == resource.object_id }
      elsif action.present?
        nil
      else
        []
      end
    end

    def add_api resource_id, action, short_desc, &block
      self.resource_ids << resource_id unless self.resource_ids.include? resource_id
      resource_name = OneboxApiDoc.base.resources.detect { |resource| resource.object_id == resource_id }.name
      route = Route.route_for(resource_name, action)
      return false unless route.present?
      url = route[:path]
      method = route[:method]
      unless self.apis.map(&:action).include? action
        api = OneboxApiDoc::Api.new(doc_id: self.object_id, resource_id: resource_id, action: action, method: method, url: url, short_desc: short_desc)
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
      api.error_ids << error.object_id
      if block_given?
        error_detail = OneboxApiDoc::ApiDefinition::ErrorDefinition.new(api.doc, &block)
        error.param_ids = error_detail.param_ids
        error.permission_ids = error_detail.permission_ids
      end
      self.errors << error
      error
    end

    def add_tag tag_name
      tag_name = tag_name.to_s
      tag = tags.detect { |tag| tag.name == tag_name }
      unless tag.present?
        tag = OneboxApiDoc::Tag.new(name: tag_name)
        tags << tag
        tag
      else
        tag
      end
    end

    def add_permission permission_name
      permission_name = permission_name.to_s
      permission = self.permissions.detect { |permission| permission.name == permission_name }
      unless permission.present?
        permission = OneboxApiDoc::Permission.new(name: permission_name)
        self.permissions << permission
        permission
      else
        permission
      end
    end

    # Params Group methods
    def add_param_group(name, &block)
      key = name.to_s
      self.param_groups[key] = block
    end

    def get_param_group(name)
      key = name.to_s
      if self.param_groups.has_key?(key)
        return self.param_groups[key]
      else
        raise "param group #{key} not defined"
      end
    end

    def nested_params_of param_id
      self.params.select { |param| param.parent_id == param_id }
    end

    private

    def set_default_value
      @resource = nil
      @version = nil
      @apis_group_by_resource = nil
      self.resource_ids = []
      self.tags = []
      self.permissions = []
      self.apis = []
      self.params = []
      self.errors = []
      self.param_groups = {}
    end

  end
end