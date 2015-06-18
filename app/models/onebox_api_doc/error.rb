module OneboxApiDoc
  class Error
    
    attr_accessor :code, :message, :permission_ids, :param_ids

    def initialize code, message, permission_ids=[], param_ids=[]
      self.code = code
      self.message = message
      self.permission_ids = permission_ids
      self.param_ids = param_ids
    end
  end
end