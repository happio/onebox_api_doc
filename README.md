# Getting Stated

Onebox Api Doc works with Rails 4.2.1 and above. You can add it to your Gemfile with

```ruby
gem 'onebox_api_doc'
```

Run `bundle install`

And run `rake onebox_api_doc:install` to create config file which look like this

```ruby
OneboxApiDoc::Engine.config do |config|

  # app name
  config.app_name = 'Api Doc'

  # where is your API Doc defined?
  config.api_docs_matcher = "api_doc/*.rb"

  # default version
  config.default_version = "0.0"

end
```

Mount documentation route by add this to routes file

```ruby
mount OneboxApiDoc::Engine => "/api_doc"
```

so you can see the api doc from the path `/api_doc`


# How to use

To add api docs create a `api_doc` directory at the root of your project and create a document file according to resource name. For example, if your resource name is `User` your document name would be `UsersApiDoc` and extends ApiDoc class just like this

```ruby
# api_doc/users_api_doc.rb
class UsersApiDoc < ApiDoc

end
```

Now you can start documenting your resources and actions (see [DSL Reference](#dsl-reference) for more info)

```ruby
# api_doc/users_api_doc.rb
class UsersApiDoc < ApiDoc

  controller_name :users
  # version "0.1" you might want to set a specific version to api 

  api :show, 'get user profile' do
    desc 'get user profile'
    tags :mobile, :web            # tags make you be able to group your apis
    permissions :member           # permissions specify that this api can be call be which roles of your app
    header do
      param "User-id", :string,   # param can be used in header, body, response and code
        desc: 'user id',
        permissions: [ :member ],
        required: true
      ...
    end
    body do
    end
    response do
      param :name, :string, 
        desc: 'user name',
        permissions: [ :member ]
    end
    error do
      code 401, "Unauthorize" do
        permissions :member
        param :error_message, :string, 
          desc: 'error message',
          permissions: [ :member ]
      end
    end
  end

  api :update, 'update user profuke' do
    ...
  end

end
```


# Documentation

* [Getting Stated](#getting-started)
* [How to use](#how-to-use)
* [Configuration Reference](#configuration-reference)
* [Document Routes Integration](#document-route-integration)
* [DSL Reference](#dsl-reference)
  * Api Doc Description
  * Api Description
    * Header Description
    * Body Description
    * Response Description
    * Error Description
      * Error Code Description
  * Param Description


# Configuration Reference

Create a configuration file by run `rake onebox_api_doc:install`, the config file will be `/config/initializers/onebox_api_doc.rb`. You can set application name, api document path and default version.

_**app_name**_
  Name of your application

_**api_docs_matcher**_
  Path where you place your api doc files

_**default_version**_
  Default version of your api to display

Example:

```ruby
OneboxApiDoc::Engine.config do |config|

  # app name
  config.app_name = 'Api Doc'

  # where is your API Doc defined?
  config.api_docs_matcher = "api_doc/*.rb"

  # default version
  config.default_version = "0.0"

end
```


# Document Routes Integration

You can change documentation url by change the mounted path on your routes file

```ruby
mount OneboxApiDoc::Engine => "/api_doc"
```

Example: if you want to your document base url to be `api` just change it to

```ruby
mount OneboxApiDoc::Engine => "/api"
```


# DSL Reference

## Api Doc Description

The following keywords are available (all are optional):

_**controller_name**_
  controller name or resource name. For example: users, notes
  if not specified the resource name will according to the file name

_**version**_
  version of the api document, if not specified all apis in this document will be in default version

