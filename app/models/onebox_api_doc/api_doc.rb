module OneboxApiDoc
  class ApiDoc < BaseObject

    #####################
    ### Class Methods ###
    #####################
    class << self

      cattr_accessor :doc, :_resource_name, :version_id, :_extension_name
      
      def inherited(subclass)
        self._resource_name = subclass.name.demodulize.gsub(/ApiDoc/,"").pluralize.underscore
        self.version_id = OneboxApiDoc.base.default_version.object_id unless version_id.present?
        self._extension_name = nil
        self.doc = nil
        # subclass.resource_name = subclass.name.demodulize.gsub(/ApiDoc/,"").pluralize.underscore
        # subclass.version_id = OneboxApiDoc.base.default_version.object_id unless subclass.version_id.present?
        # subclass._extension_name = nil
        # subclass.doc = nil
        subclass
      end

      def resource_name name
        self._resource_name = name
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
        resource = OneboxApiDoc.base.add_resource(self._resource_name)
        self.doc.add_api(resource.object_id, action, short_desc, auto_route: true, &block)
      end

      def get url, short_desc="", &block
        set_up_doc
        resource = OneboxApiDoc.base.add_resource(self._resource_name)
        self.doc.add_api(resource.object_id, 'GET', url, short_desc, &block)
      end

      def put url, short_desc="", &block
        set_up_doc
        resource = OneboxApiDoc.base.add_resource(self._resource_name)
        self.doc.add_api(resource.object_id, 'PUT', url, short_desc, &block)
      end

      def delete url, short_desc="", &block
        set_up_doc
        resource = OneboxApiDoc.base.add_resource(self._resource_name)
        self.doc.add_api(resource.object_id, 'DELETE', url, short_desc, &block)
      end

      def post url, short_desc="", &block
        set_up_doc
        resource = OneboxApiDoc.base.add_resource(self._resource_name)
        self.doc.add_api(resource.object_id, 'POST', url, short_desc, &block)
      end

      def def_param_group name, &block
        set_up_doc
        self.doc.add_param_group name, &block
      end

      def def_error_group name, &block
        set_up_doc
        self.doc.add_error_group name, &block
      end

      def set_up_doc
        self.doc ||= OneboxApiDoc.base.add_doc(self.version_id)
      end

    end

  end
end