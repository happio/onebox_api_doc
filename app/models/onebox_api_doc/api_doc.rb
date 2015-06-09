module OneboxApiDoc
  class ApiDoc

    class << self

      attr_accessor :_controller_name, :_version, :_default_version, :_apis
      # for extension
      attr_accessor :_extension_name, :_core_versions
      
      def inherited(subclass)
        subclass._controller_name = subclass.name.demodulize.gsub(/ApiDoc/,"").pluralize.underscore
        subclass._version = OneboxApiDoc.base.default_version
        subclass._core_versions = []
      end

      ##############################
      ####### Setter Methods #######
      ##############################

      def controller_name name
        @_controller_name = name.to_s
      end

      # for extension
      def extension_name name
        @_extension_name = name.to_s
      end

      # core_version is for extension
      def version version, core_version: {}
        if core_version.blank?
          @_version = OneboxApiDoc.base.add_version version.to_s
        elsif @_extension_name.present?
          @_version = OneboxApiDoc.base.add_extension_version @_extension_name, version.to_s
          set_core_versions core_version
        end
      end

      def api action, short_desc="", &block
        @_apis ||= []
        api = OneboxApiDoc::Api.new(_controller_name, action, short_desc, &block)
        @_apis << api
        @_version.apis << api
        OneboxApiDoc.base.add_api api
      end

      def def_param_group name, &block
        OneboxApiDoc.base.add_param_group name, &block
      end

      def set_core_versions core_version
        # all_core_versions = OneboxApiDoc.base.core_versions
        # ...
        # TODO: set core version incase of this is extension api doc
      end

    end

  end
end