require 'rails/generators/base'

module OneboxApiDoc
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../../templates', __FILE__)

      def copy_initializer_file
        copy_file "initializers/onebox_api_doc.rb", "config/initializers/onebox_api_doc.rb"
      end

      def add_route
        route "mount OneboxApiDoc::Engine => '/docs'"
      end

    end
  end
end
