module OneboxApiDoc
  class Resource < OneboxApiDoc::Object
    
    attr_accessor :name

    def initialize name
      self.name = name.to_s
      super
      self
    end
  end
end