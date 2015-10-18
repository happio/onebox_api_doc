require "onebox_api_doc/engine"

require "sass-rails"
require "haml-rails"
require "zeroclipboard-rails"

require 'actionpack/page_caching'
require 'actionpack/action_caching'

module OneboxApiDoc

  require "onebox_api_doc/onebox_api_doc_module"
  require "onebox_api_doc/route"
  require "onebox_api_doc/api_definition"
  
end