module OneboxApiDoc
  class App < BaseObject
    
    attr_accessor :name
    
    def is_extension?
      self.name != "main"
    end
  end
end