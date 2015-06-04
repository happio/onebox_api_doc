module OneboxApiDoc
  class Tag
    
    attr_accessor :name, :apis

    def initialize name
      self.name = name.to_s
      self.apis = []
      # OneboxApiDoc.base.add_tag self
      self
    end
  end
end