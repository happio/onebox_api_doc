module OneboxApiDoc
  class Engine < ::Rails::Engine
    isolate_namespace OneboxApiDoc

    initializer "onebox_api_doc.assets.precompile" do |app|
      bower_path = root.join('vendor', 'assets', 'bower_components')
      bower_path.tap do |path|
        app.config.assets.paths << path.join('semantic-ui', 'dist').to_s
        # app.config.assets.paths << path.join('bootstrap-sass-official','assets','fonts')
        # app.config.assets.paths << path.join('font-awesome','fonts')
      end
      app.config.assets.precompile << %r(\.(?:eot|svg|ttf|woff|woff2)$)
    end

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