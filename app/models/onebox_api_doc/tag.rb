module OneboxApiDoc
  class Tag
    
    attr_accessor :name, :apis

    def initialize name
      self.name = name.to_s
      self.apis = []
      self
    end
  end
end