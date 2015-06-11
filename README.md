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

Now you can start documenting your resources and actions (see DSL Reference for more info)

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