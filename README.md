Onebox Api Doc works with Rails 4.2.1 and above. You can add it to your Gemfile with:

    gem 'onebox_api_doc'

Run `bundle install`

And run `rake onebox_api_doc:install` to create config file which look like this

    OneboxApiDoc::Engine.config do |config|
    
      # app name
      config.app_name = 'Api Doc'
    
      # where is your API Doc defined?
      config.api_docs_matcher = "api_doc/*.rb"
    
      # default version
      config.default_version = "0.0"
    
    end

Mount documentation route by add this to routes file

    mount OneboxApiDoc::Engine => "/api_doc"

so you can see the api doc from the path `/api_doc`