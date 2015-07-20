require "onebox_api_doc/engine"

require "jquery-rails"
require "sass-rails"
require "haml-rails"
require "semantic-ui-sass"
require "zeroclipboard-rails"

require 'actionpack/page_caching'
require 'actionpack/action_caching'

require 'friendly_id'

module OneboxApiDoc

  require "onebox_api_doc/onebox_api_doc_module"
  require "onebox_api_doc/route"
  require "onebox_api_doc/api_definition"
  
end
