module OneboxApiDoc
  class Engine < ::Rails::Engine
    isolate_namespace OneboxApiDoc

    class << self

      # App name
      mattr_accessor :app_name do 'API DOC' end

      # where is your API defined?
      mattr_accessor :api_docs_matcher do "api_doc/*.rb" end

      def config(&block)
        yield self
      end

    end
  end
end
