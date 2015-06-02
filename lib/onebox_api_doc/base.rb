module OneboxApiDoc
  class Base

    @all_tags = []
    @all_permissions = []

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
    end

    def api_docs_paths
      Dir.glob(Rails.root.join(*OneboxApiDoc::Engine.api_docs_matcher.split("/")))
    end

    def all_tags
      @all_tags
    end

    def all_permissions
      @all_permissions
    end

    private

    def load_api_doc_from_file(api_doc_file)
      require api_doc_file
      api_doc_class_name = api_doc_file.gsub(/\A.*\/api_doc\//,"").gsub(/\.\w*\Z/,"").camelize
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