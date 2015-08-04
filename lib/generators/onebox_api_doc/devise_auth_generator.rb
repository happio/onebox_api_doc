require 'rails/generators/base'

module OneboxApiDoc
  module Generators
    class DeviseAuthGenerator < Rails::Generators::Base
      source_root File.expand_path('../../templates', __FILE__)
      include Rails::Generators::Migration

      def self.next_migration_number(path)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end

      def create_model_files
        template "models/developer.rb", "app/models/onebox_api_doc/developer.rb"
      end

      def create_migrations_files
        migration_template "migrations/devise_create_onebox_api_doc_developers.rb", "db/migrate/devise_create_onebox_api_doc_developers.rb"
      end

      def add_route
        route "mount OneboxApiDoc::Engine => '/docs'"
      end

    end
  end
end