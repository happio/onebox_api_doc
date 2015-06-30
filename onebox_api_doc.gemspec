$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "onebox_api_doc/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "onebox_api_doc"
  s.version     = OneboxApiDoc::VERSION
  s.authors     = ["Carryall"]
  s.email       = ["carryall369@gmail.com"]
  s.homepage    = ""
  s.summary     = "Api documentation for apps and engines."
  s.description = "Api documentation for apps and engines."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  # s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 4.2.1"
  s.add_dependency "responders", ">= 2.0"
  s.add_dependency "semantic-ui-sass", "~> 1.12.3.0"
  s.add_dependency "sass-rails"
  s.add_dependency "haml-rails"
  s.add_dependency "jquery-rails"
  s.add_dependency "zeroclipboard-rails"

  s.add_dependency "actionpack-page_caching"
  s.add_dependency "actionpack-action_caching"
  
  # s.add_development_dependency "sqlite3"

end
