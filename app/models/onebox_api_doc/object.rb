module OneboxApiDoc
  class Object

    attr_accessor :id

    def initialize options=[]
      self.id = OneboxApiDoc.base.next_index(self.class.name)
      self
    end
    
  end
end