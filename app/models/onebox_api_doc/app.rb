module OneboxApiDoc
  class App
    
    attr_accessor :name

    def initialize name
      self.name = name.to_s
    end

    def is_extension?
      self.name != "main"
    end
  end
end