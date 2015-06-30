module OneboxApiDoc
  class ApiDoc < BaseObject

    #####################
    ### Class Methods ###
    #####################
    class << self

      cattr_accessor :doc, :resource_name, :version_id, :_extension_name
      
      def inherited(subclass)
        self.resource_name = subclass.name.demodulize.gsub(/ApiDoc/,"").pluralize.underscore
        version = OneboxApiDoc.base.default_version
        self.version_id = version.object_id
        self._extension_name = nil
        self.doc = nil
        subclass
      end

      def controller_name name
        self.resource_name = name
      end

      def def_tags &block
        set_up_doc
        block.call if block_given?
      end

      def tag slug, name, default: false
        set_up_doc
        self.doc.add_tag slug, name, default: default
      end

      def def_permissions &block
        set_up_doc
        block.call if block_given?
      end

      def permission slug, name
        set_up_doc
        self.doc.add_permission slug, name
      end

      # for extension
      def extension_name extension_name
        self._extension_name = extension_name.to_s
      end

      # core_version is for extension
      def version version_name, core_version: {}
        if core_version.blank?
          version = OneboxApiDoc.base.add_version(version_name.to_s)
        else
          version = OneboxApiDoc.base.add_extension_version(version_name.to_s, self.doc._extension_name)
        end
        self.version_id = version.object_id
        version
      end

      def api action, short_desc="", &block
        set_up_doc
        resource = OneboxApiDoc.base.add_resource(self.resource_name)
        self.doc.add_api(resource.object_id, action, short_desc, &block)
      end

      def def_param_group name, &block
        set_up_doc
        self.doc.add_param_group name, &block
      end

      def set_up_doc
        self.doc ||= OneboxApiDoc.base.add_doc(self.version_id)
      end

    end

  end
end