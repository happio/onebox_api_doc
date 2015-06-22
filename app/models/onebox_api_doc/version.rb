module OneboxApiDoc
  class Version < BaseObject
    
    # attr_accessor :extension_name, :version, :apis

    # def initialize version, extension_name = nil
    #   self.extension_name = extension_name.to_s if extension_name.present?
    #   self.version = version.to_s
    #   self.apis = []
    #   self
    # end

    attr_accessor :app_id, :name

    def is_extension?
      OneboxApiDoc.base.apps.select { |app| app.object_id == self.app_id }.first.is_extension?
    end

    # def get_api(resource_name, action=nil)
    #   if action.present?
    #     apis.select { |api| api._controller_name == resource_name.to_s and api._action == action.to_s }.first
    #   else
    #     apis.select { |api| api._controller_name == resource_name.to_s }
    #   end
    # end

    # def apis_group_by_resources
    #   result = {}
    #   apis.each do |api|
    #     result[api._controller_name] ||= []
    #     result[api._controller_name] << api
    #   end
    #   result
    # end
    
  end
end