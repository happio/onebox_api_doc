
OneboxApiDoc::Engine.config do |config|

  # app name
  config.app_name = 'Api Doc'

  # where is your API Doc and its load piorities
  config.api_doc_paths do |doc|
    # doc.path "path", root: your_root_path, priority: 0
    # root is optional, default root is Rails.root
    # priority is optional, default priority is 100
    doc.path "api_doc/**/*.rb"
    # Ex:
    # doc.path "api_docs/**/*_api_doc.rb", root: OneboxCore::Engine.root, priority: 0
    # doc.path "api_docs/**/*_api_doc.rb", root: OneboxBankTransfer::Engine.root
  end

  # default version
  config.default_version = "0.0.0"

  # authentication
  # config.auth_method = "authenticate_developer!"

end
