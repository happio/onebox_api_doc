module OneboxApiDoc
  class Version
    
    attr_accessor :extension_name, :version, :apis

    def initialize extension_name = nil, version
      self.extension_name = extension_name.to_s if extension_name.present?
      self.version = version.to_s
      self.apis = []
      self
    end

    def is_extension?
      extension_name.present?
    end

    def apis_by_resources
      result = {}
      apis.each do |api|
        result[api._controller_name] ||= []
        result[api._controller_name] << api
      end
      result
    end
  end
end