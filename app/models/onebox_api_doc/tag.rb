module OneboxApiDoc
  class Tag < BaseObject
    
    # attr_accessor :name, :apis

    # def initialize name
    #   self.name = name.to_s
    #   self.apis = []
    #   self
    # end

    # def apis_by_resources
    #   result = {}
    #   apis.each do |api|
    #     result[api._controller_name] ||= []
    #     result[api._controller_name] << api
    #   end
    #   result
    # end

    attr_accessor :name
    
  end
end