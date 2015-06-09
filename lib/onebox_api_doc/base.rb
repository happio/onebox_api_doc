module OneboxApiDoc
  class Base

    attr_reader :all_tags, :all_apis, :all_permissions, :default_version,
      :core_versions, :extension_versions, :param_groups

    def initialize
      set_default_value
    end

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

    def api_docs
      OneboxApiDoc::ApiDoc.subclasses
    end

    def get_api(version_name, resource_name, action)
      version = @core_versions.select { |v| v.version == version_name }.first
      version.get_api(resource_name, action) if version.present?
    end

    def add_tag tag_name
      tag = @all_tags.select { |tag| tag.name == tag_name.to_s }.first
      unless tag.present?
        tag = OneboxApiDoc::Tag.new(tag_name.to_s)
        @all_tags << tag
      end
      tag
    end

    def add_api api
      @all_apis << api unless @all_apis.include? api
    end

    def add_version version_name
      version = @core_versions.select { |version| version.version == version_name.to_s  }.first
      unless version.present?
        version = OneboxApiDoc::Version.new(version_name.to_s)
        core_versions << version
      end
      version
    end

    def add_extension_version extension_name, version_name
      all_versions = @extension_versions[extension_name.to_s] ||= []
      version = all_versions.select { |version| version.version == version_name.to_s  }.first
      unless version.present?
        version = OneboxApiDoc::Version.new(version_name.to_s)
        all_versions << version
      end
      version
    end

    def add_permission role
      role = role.to_s
      @all_permissions << role unless @all_permissions.include? role
      role
    end

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
      @all_tags = []
      @all_permissions = []
      @all_apis = []
      @core_versions = []
      @extension_versions = {}
      @param_groups = {}
      @default_version = OneboxApiDoc::Version.new(OneboxApiDoc::Engine.default_version)
    end

    def load_api_doc_from_file(api_doc_file)
      require api_doc_file
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