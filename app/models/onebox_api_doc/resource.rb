module OneboxApiDoc
  class Resource
    
    attr_accessor :name

    def initialize name
      self.name = name.to_s
    end
  end
end