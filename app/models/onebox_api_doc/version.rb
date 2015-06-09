module OneboxApiDoc
  class Version
    
    attr_accessor :extension_name, :version, :apis

    def initialize version, extension_name = nil
      self.extension_name = extension_name.to_s if extension_name.present?
      self.version = version.to_s
      self.apis = []
      self
    end

    def is_extension?
      extension_name.present?
    end

    def get_api(resource_name, action)
      apis.select { |api| api._controller_name == resource_name.to_s and api._action == action.to_s }.first
    end

    def apis_by_resources
      result = {}
      apis.each do |api|
        result[api._controller_name] ||= []
        result[api._controller_name] << api
      end
      result
    end

    class << self
      def from_to from, to

      end
      def from from
      end
      def to to
      end
    end
  end
end