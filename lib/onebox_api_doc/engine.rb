module OneboxApiDoc
  class Engine < ::Rails::Engine
    isolate_namespace OneboxApiDoc

    class << self

      # App name
      mattr_accessor :app_name do 'API DOC' end

      # API Doc paths with root and priority
      mattr_accessor :doc_paths do [] end

      # default version
      mattr_accessor :default_version do "0.0" end

      # authentication
      mattr_accessor :auth_method

      def auth?
        auth_method.present?
      end

      def config(&block)
        yield self
      end

      def api_doc_paths &block
        yield self
      end

      # root and priority are optional
      # path with least priority will load first
      def path file_path, root: nil, priority: 100
        root ||= Rails.root
        doc_paths << { path: file_path, root: root, priority: priority }
      end

    end
  end
end