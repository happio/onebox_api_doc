module OneboxApiDoc
  class ApiDoc

    class << self

      attr_accessor :_controller_name, :_version, :_apis
      # for extension
      attr_accessor :_extension_name, :_core_versions
      
      def inherited(subclass)
        subclass._controller_name = subclass.name.demodulize.gsub(/ApiDoc/,"").pluralize.underscore
        subclass._version = "0.0"
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
      end

      # core_version is for extension
      def version name, core_version: {}
        @_version = name.to_s
      end

      def api action, short_desc="", &block
        @_apis ||= []
        @_apis << OneboxApiDoc::Api.new(@_controller_name, action, short_desc, &block)
      end
      
    end
    
  end
end