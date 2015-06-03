module OneboxApiDoc
  class Tag
    
    attr_accessor :name, :apis

    def initialize name
      self.name = name.to_s
      self.apis = []
      OneboxApiDoc::Base.add_new_tag self
    end

    class << self

      def find_or_initialize name
        name = name.to_s
        tag = OneboxApiDoc::Base.all_tags.select{ |t| t.name == name } if OneboxApiDoc::Base.all_tags.present?
        tag = self.new(name) unless tag.present?
        tag
      end

    end

  end
end