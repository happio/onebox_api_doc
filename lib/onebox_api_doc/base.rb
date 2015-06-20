module OneboxApiDoc
  class Base

    attr_reader :all_tags, :all_apis, :all_permissions, #:default_version,
      :core_versions, :extension_versions, :param_groups


    attr_accessor :apps, :versions, :resources, :docs, :params
    attr_writer :main_app#, :default_version

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
      app ||= OneboxApiDoc::App.new("main")
      self.apps << app unless self.apps.include? app
      app
    end

    # default version
    def default_version
      version ||= OneboxApiDoc::Version.new(OneboxApiDoc::Engine.default_version, main_app.object_id)
      self.versions << version unless self.versions.include? version
      version
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
      unless self.resources.map(&:name).include? resource_name
        resource = OneboxApiDoc::Resource.new(resource_name)
        self.resources << resource
        resource
      else
        self.resources.select { |resource| resource.name == resource_name }.first
      end
    end

    def add_version version_name
      unless self.versions.map(&:name).include? version_name
        version = OneboxApiDoc::Version.new(version_name, main_app.object_id)
        self.versions << version
        version
      else
        self.versions.select { |version| version.name == version_name }.first
      end
    end

    def add_app app_name
      unless self.apps.map(&:name).include? app_name
        app = OneboxApiDoc::App.new(app_name)
        self.apps << app
        app
      else
        self.apps.select { |app| app.name == app_name }.first
      end
    end

    def add_doc klass, version_id, resource_id
      doc = self.docs.select { |doc| doc.class == klass and doc.version_id == version_id and doc.resource_id == resource_id }.first
      unless doc.present?
        doc = klass.new(version_id, resource_id)
        self.docs << doc
        doc
      else
        doc
      end
    end

    def add_param name, type, options={}, &block
      param = OneboxApiDoc::Param.new(name, type, options, &block)
      self.params << param
      param
    end

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

    # Model Indexing
    def next_index klass_name
      klass_name = klass_name.demodulize.underscore.to_sym
      @index[klass_name] ||= 0
      @index[klass_name] += 1
    end

    # Param Helper
    def nested_params_of param_id
      # all_params.select { |param| param.parent_id == param_id }
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