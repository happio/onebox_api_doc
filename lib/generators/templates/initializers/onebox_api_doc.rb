
OneboxApiDoc::Engine.config do |config|

  # app name
  config.app_name = 'Api Doc'

  # where is your API Doc defined?
  config.root_resource = Rails.root
  config.api_docs_matcher = "api_doc/**/*.rb"

  # default version
  config.default_version = "0.0.0"

  # authentication
  # config.auth_method = "authenticate_developer!"

end
