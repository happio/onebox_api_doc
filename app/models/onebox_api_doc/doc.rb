module OneboxApiDoc
  class Doc < BaseObject

    attr_accessor :tags, :permissions, :apis, :params, :errors, :param_groups, :error_groups
    attr_accessor :version_id, :extension_name, :resource_ids
    attr_accessor :annoucements

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
      self.apis.each do |api|
        result[api.resource.name] ||= []
        result[api.resource.name] << api
      end
      result
    end

    def get_api resource_name, method, url
      resource = OneboxApiDoc.base.get_resource resource_name
      self.apis.detect { |api| api.resource_id == resource.object_id and api.method == method.to_s.upcase and api.url == url }
    end

    def get_apis_by_resource resource_name
      resource = OneboxApiDoc.base.get_resource resource_name
      resource.present? ? self.apis.select { |api| api.resource_id == resource.object_id } : []
    end

    # def add_api resource_id, action, short_desc, method: nil, auto_route: false, &block
    #   self.resource_ids << resource_id unless self.resource_ids.include? resource_id
    #   resource_name = OneboxApiDoc.base.resources.detect { |resource| resource.object_id == resource_id }.name
    #   # if auto_route
    #   route = Route.route_for(resource_name, action)
    #   return false unless route.present?
    #   url = route[:path]
    #   method = route[:method]
    #   # else
    #     # url = action
    #   # end
    #   unless self.apis.map(&:url).include? url
    #     api = OneboxApiDoc::Api.new(doc_id: self.object_id, resource_id: resource_id, action: action, method: method, url: url, short_desc: short_desc)
    #     self.apis << api
    #   else
    #     api = self.apis.detect { |api| api.url == url }
    #   end

    #   OneboxApiDoc::ApiDefinition.new(api, &block) if block_given?
    #   api
    # end

    def add_api resource_id, method, url, short_desc, auto_route: false, &block
      self.resource_ids << resource_id unless self.resource_ids.include? resource_id
      resource_name = OneboxApiDoc.base.resources.detect { |resource| resource.object_id == resource_id }.name
      unless self.apis.map { |api| "#{api.method} #{api.url}" }.include? "#{method} #{url}"
        api = OneboxApiDoc::Api.new(doc_id: self.object_id, resource_id: resource_id, method: method, url: url, short_desc: short_desc)
        self.apis << api
      else
        api = self.apis.detect { |api| api.url == url }
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

    def add_annoucement type, *attrs
      annoucement_class = "OneboxApiDoc::Annoucements::#{type.to_s.capitalize}".classify.constantize
      annoucement = annoucement_class.new(*attrs)
      self.annoucements << annoucement
      annoucement
    end

    def add_error api, error_status, error_message, &block
      error = OneboxApiDoc::Error.new(doc_id: self.object_id, api_id: api.object_id, code: error_status, message: error_message, &block)
      api.error_ids << error.object_id
      if block_given?
        error_detail = OneboxApiDoc::ApiDefinition::ErrorDefinition.new("error", api.doc, api.object_id, &block)
        error.permission_ids = error_detail.permission_ids
      end
      self.errors << error
      error
    end

    def default_tag
      self.tags.detect { |tag| tag.default }
    end

    def add_tag slug, name, default: false
      tag = self.tags.detect { |tag| tag.slug == slug.to_s }
      unless tag.present?
        tag ||= OneboxApiDoc::Tag.new(slug: slug.to_s, name: name.to_s, default: default, doc_id: self.object_id)
        self.tags << tag
      end
      tag
    end

    def get_tag tag_slug
      tag_slug = tag_slug.to_s
      raise "tag #{tag_slug} not defined" unless self.tags.map(&:slug).include? tag_slug
      self.tags.detect { |tag| tag.slug == tag_slug }
    end

    def add_permission slug, name
      name = name.to_s
      permission = self.permissions.detect { |permission| permission.name == name }
      unless permission.present?
        permission = OneboxApiDoc::Permission.new(slug: slug, name: name)
        self.permissions << permission
        permission
      else
        permission
      end
    end

    def get_permission permission_slug
      permission_slug = permission_slug.to_s
      raise "permission #{permission_slug} not defined" unless self.permissions.map(&:slug).include? permission_slug
      self.permissions.detect { |permission| permission.slug == permission_slug }
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

    # Error Code Group methods
    def add_error_group(name, &block)
      key = name.to_s
      self.error_groups[key] = block
    end

    def get_error_group(name)
      key = name.to_s
      if self.error_groups.has_key?(key)
        return self.error_groups[key]
      else
        raise "error group #{key} not defined"
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
      self.error_groups = {}
      self.annoucements = []
    end

  end
end