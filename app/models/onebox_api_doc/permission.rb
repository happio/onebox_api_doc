module OneboxApiDoc
  class Permission < OneboxApiDoc::Object
    attr_accessor :name

    def initialize name
      self.name = name.to_s
      super
    end
  end
end