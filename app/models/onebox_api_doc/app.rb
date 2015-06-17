module OneboxApiDoc
  class App < OneboxApiDoc::Object
    
    attr_accessor :name

    def initialize name
      super()
      self.name = name.to_s
      self
    end
  end
end