module OneboxApiDoc
  class Annoucement < BaseObject
    
    attr_accessor :doc_id

    def message
      "Annoucement"
    end

    def doc
      @doc ||= OneboxApiDoc.base.docs.detect { |doc| doc.object_id == doc_id }
    end
  end
end

require_relative 'annoucements/param.rb'
require_relative 'annoucements/api.rb'
require_relative 'annoucements/news.rb'
