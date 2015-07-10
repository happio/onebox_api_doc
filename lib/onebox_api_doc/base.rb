module OneboxApiDoc
  class Base

    attr_accessor :apps, :versions, :resources, :docs, :params

    def initialize
      set_default_value
    end

    # loading document
    def reload_document
      unload_document
      load_document
    end

    def load_document
      rails_mark_classes_for_reload

      api_docs_paths.each do |f|
        load_api_doc_from_file f
      end
    end

    def unload_document
      unload_api_doc_from_class
      set_default_value
    end

    def api_docs_paths
      Dir.glob(OneboxApiDoc::Engine.root_resource.join(*OneboxApiDoc::Engine.api_docs_matcher.split("/")))
    end

    def main_app
      @main_app ||= self.apps.detect { |app| app.name == "main" }
      unless @main_app.present?
        @main_app = OneboxApiDoc::App.new(name: "main")
        self.apps << @main_app
        @main_app
      else
        @main_app
      end
    end

    def extension_apps
      @extension_apps ||= self.apps.select { |app| app.name != "main" }
    end

    def default_version
      @default_version ||= self.versions.detect { |version| version.name == OneboxApiDoc::Engine.default_version and version.app_id == main_app.object_id }
      unless @default_version.present?
        @default_version = OneboxApiDoc::Version.new(name: OneboxApiDoc::Engine.default_version, app_id: main_app.object_id)
        self.versions << @default_version
        @default_version
      else
        @default_version
      end
    end

    def main_versions
      @main_versions ||= self.versions.select { |version| not version.is_extension? }
    end

    def lastest_main_version
      @lastest_main_version ||= main_versions.sort { |version1, version2| Gem::Version.new(version1.name) <=> Gem::Version.new(version2.name) }.last
    end

    def extension_versions extension_name = nil
      if extension_name.present?
        self.versions.select { |version| version.is_extension? and version.app.name == extension_name.to_s }
      else
        self.versions.select { |version| version.is_extension? }
      end
    end

    def lastest_extension_version extension_name = nil
      extension_versions(extension_name).sort { |version1, version2| Gem::Version.new(version1.name) <=> Gem::Version.new(version2.name) }.last
    end

    # group apis by resource name
    # return hash with resource name as key and array of api object as value
    def apis_group_by_resource(version = nil)
      version = default_version unless version.present?
      get_doc(version.name).apis_group_by_resource
    end

    def get_tags(version = nil)
      version = default_version unless version.present?
      get_doc(version.name).tags
    end

    # get api by version, resource and action (optional)
    def get_api options={}
      version_name = options[:version]
      resource_name = options[:resource_name]
      action_name = options[:action_name]
      doc = get_doc(version_name)
      if doc.present?
        doc.get_apis(resource_name, action_name)
      else
        action_name.present? ? nil : []
      end
    end

    def get_version version_name
      self.versions.detect { |version| version.name == version_name.to_s }
    end

    def get_resource resource_name
      self.resources.detect { |resource| resource.name == resource_name.to_s }
    end

    def get_doc version_name
      version_id = self.get_version(version_name).object_id
      self.docs.detect { |doc| doc.version_id == version_id }
    end

    def get_app app_name
      self.apps.detect { |app| app.name == app_name.to_s }
    end

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

    def add_doc version_id
      doc = self.docs.detect { |doc| doc.version_id == version_id}
      unless doc.present?
        doc = OneboxApiDoc::Doc.new(version_id: version_id)
        self.docs << doc
        doc
      else
        doc
      end
    end
    
    private

    def set_default_value
      @main_app = nil
      @extension_apps = nil
      @default_version = nil
      @main_versions = nil
      @lastest_main_version = nil

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

    def unload_api_doc_from_class
      OneboxApiDoc::ApiDoc.subclasses.each do |api_doc_class|
        api_doc_class_name = api_doc_class.name
        namespaces = api_doc_class_name.deconstantize
        class_name = api_doc_class_name.demodulize.to_sym
        if namespaces.present?
          object = namespaces.constantize
          object.send(:remove_const, class_name) if object.const_defined?(class_name)
        else
          Object.send(:remove_const, class_name) if Object.const_defined?(class_name)
        end
      end
    end

    # Since Rails 3.2, the classes are reloaded only on file change.
    # We need to reload all the controller classes to rebuild the
    # docs, therefore we just force to reload all the code. This
    # happens only when reload_controllers is set to true and only
    # when showing the document.
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