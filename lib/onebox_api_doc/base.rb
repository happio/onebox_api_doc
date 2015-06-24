module OneboxApiDoc
  class Base

    # attr_reader :all_tags, :all_apis, :all_permissions, #:default_version,
    #   :core_versions, :extension_versions, :param_groups


    attr_accessor :apps, :versions, :resources, :docs, :params
    # attr_writer :main_app #, :default_version

    # attributes for indexing
    attr_reader :index

    def initialize
      set_default_value
    end

    # loading documentation
    def reload_documentation
      unload_documentation
      load_documentation
    end

    def load_documentation
      rails_mark_classes_for_reload

      api_docs_paths.each do |f|
        load_api_doc_from_file f
      end
    end

    def unload_documentation
      api_docs_paths.each do |f|
        unload_api_doc_from_file f
      end
      set_default_value
    end

    def api_docs_paths
      Dir.glob(Rails.root.join(*OneboxApiDoc::Engine.api_docs_matcher.split("/")))
    end

    # main_app
    def main_app
      main_app = self.apps.detect { |app| app.name == "main" }
      unless main_app.present?
        main_app = OneboxApiDoc::App.new(name: "main")
        self.apps << main_app
        main_app
      else
        main_app
      end
    end

    def extension_apps
      self.apps.select { |app| app.name != "main" }
    end

    # default version
    def default_version
      default_version = self.versions.detect { |version| version.name == OneboxApiDoc::Engine.default_version and version.app_id == main_app.object_id }
      unless default_version.present?
        default_version = OneboxApiDoc::Version.new(name: OneboxApiDoc::Engine.default_version, app_id: main_app.object_id)
        self.versions << default_version
        default_version
      else
        default_version
      end
    end

    # get api by version, resource and action (optional)
    def get_api options={}
      version_name = options[:version]
      resource_name = options[:resource_name]
      action_name = options[:action_name]
      doc = get_doc(version_name, resource_name)
      return action_name.present? ? nil : [] unless doc.present?
      doc.get_apis(action_name)
    end

    def get_version version_name
      self.versions.detect { |version| version.name == version_name.to_s }
    end

    def get_resource resource_name
      self.resources.detect { |resource| resource.name == resource_name.to_s }
    end

    def get_doc version_name, resource_name
      version_id = self.get_version(version_name).object_id
      resource_id = self.get_resource(resource_name).object_id
      self.docs.detect { |doc| doc.version_id == version_id and doc.resource_id == resource_id }
    end

    def get_app app_name
      self.apps.detect { |app| app.name == app_name.to_s }
    end

    def main_versions
      self.versions.select { |version| not version.is_extension? }
    end

    def extension_versions
      self.versions.select { |version| version.is_extension? }
    end

    # def api_docs
    #   OneboxApiDoc::ApiDoc.subclasses
    # end

    # def get_version version_name
    #   @core_versions.select { |v| v.version == version_name.to_s }.first
    # end

    # def get_api version_name, resource_name, action=nil
    #   version = get_version(version_name)
    #   version.get_api(resource_name, action) if version.present?
    # end

    # def get_tag tag_name
    #   @all_tags.select { |tag| tag.name == tag_name.to_s }.first
    # end

    def add_resource resource_name
      resource_name = resource_name.to_s
      unless self.resources.map(&:name).include? resource_name
        resource = OneboxApiDoc::Resource.new(name: resource_name)
        self.resources << resource
        resource
      else
        self.resources.detect { |resource| resource.name == resource_name }
      end
    end

    def add_version version_name
      version_name = version_name.to_s
      version = self.versions.detect { |version| version.name == version_name and version.app_id == main_app.object_id }
      unless version.present?
        version = OneboxApiDoc::Version.new(name: version_name, app_id: main_app.object_id)
        self.versions << version
        version
      else
        version
      end
    end

    def add_extension_version version_name, extension_name
      extension = self.add_app extension_name
      extension_version = self.versions.detect { |version| version.name == version_name and version.app_id == extension.object_id }
      unless extension_version.present?
        extension_version = OneboxApiDoc::Version.new(name: version_name, app_id: extension.object_id)
        self.versions << extension_version
        extension_version
      else
        extension_version
      end
    end

    def add_app app_name
      app_name = app_name.to_s
      app = self.get_app app_name
      unless app.present?
        app = OneboxApiDoc::App.new(name: app_name)
        self.apps << app
        app
      else
        app
      end
    end

    def add_doc klass, version_id, resource_id
      doc = self.docs.detect { |doc| doc.class == klass and doc.version_id == version_id and doc.resource_id == resource_id }
      unless doc.present?
        doc = klass.new(version_id: version_id, resource_id: resource_id)
        self.docs << doc
        doc
      else
        doc
      end
    end

    # def add_param name, type, options={}, &block
    #   param = OneboxApiDoc::Param.new(name, type, options, &block)
    #   self.params << param
    #   param
    # end

    # def add_param action, short_desc=""
    #   OneboxApiDoc::Api.new(action, short_desc, &block)
    # end

    # def add_tag tag_name
    #   tag = get_tag tag_name
    #   unless tag.present?
    #     tag = OneboxApiDoc::Tag.new(tag_name.to_s)
    #     @all_tags << tag
    #   end
    #   tag
    # end

    # def add_api api
    #   @all_apis << api unless @all_apis.include? api
    # end

    # def add_version version_name
    #   version = get_version version_name
    #   unless version.present?
    #     version = OneboxApiDoc::Version.new(version_name.to_s)
    #     @core_versions << version
    #   end
    #   version
    # end

    # def add_extension_version extension_name, version_name
    #   all_versions = @extension_versions[extension_name.to_s] ||= []
    #   version = all_versions.select { |version| version.version == version_name.to_s  }.first
    #   unless version.present?
    #     version = OneboxApiDoc::Version.new(version_name.to_s)
    #     all_versions << version
    #   end
    #   version
    # end

    # def add_permission role
    #   role = role.to_s
    #   @all_permissions << role unless @all_permissions.include? role
    #   role
    # end



    # Params Group
    def add_param_group(name, &block)
      key = name.to_s
      @param_groups[key] = block
    end

    def get_param_group(name)
      key = name.to_s
      if @param_groups.has_key?(key)
        return @param_groups[key]
      else
        raise "param group #{key} not defined"
      end
    end

    
    private

    def set_default_value
      # @all_tags = []
      # @all_permissions = []
      # @all_apis = []
      # @core_versions = []
      # @extension_versions = {}
      # @param_groups = {}

      # @index = {}
      
      self.apps = []
      self.versions = []
      self.docs = []
      self.resources = []
      self.params = []
    end

    def load_api_doc_from_file(api_doc_file)
      load api_doc_file
      api_doc_file.gsub(/\A.*\/api_doc\//,"").gsub(/\.\w*\Z/,"").camelize
    end

    def unload_api_doc_from_file(api_doc_file)
      api_doc_class_name = api_doc_file.gsub(/\A.*\/api_doc\//,"").gsub(/\.\w*\Z/,"").camelize
      klass = Object.const_get(api_doc_class_name) rescue nil
      Object.send(:remove_const, api_doc_class_name) if klass.is_a?(Class)
    end

    # Since Rails 3.2, the classes are reloaded only on file change.
    # We need to reload all the controller classes to rebuild the
    # docs, therefore we just force to reload all the code. This
    # happens only when reload_controllers is set to true and only
    # when showing the documentation.
    #
    # If cache_classes is set to false, it does nothing,
    # as this would break loading of the api doc.
    def rails_mark_classes_for_reload
      unless Rails.application.config.cache_classes
        ActionDispatch::Reloader.cleanup!
        # init_env
        # reload_examples
        ActionDispatch::Reloader.prepare!
      end
    end

  end
end