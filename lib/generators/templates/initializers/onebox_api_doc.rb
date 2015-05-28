
OneboxApiDoc::Engine.config do |config|

  # App name
  config.app_name = 'Api Doc'

  # where is your API Doc defined?
  config.api_docs_matcher = "#{Rails.root}/api_doc/*.rb"

end
