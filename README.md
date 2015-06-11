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
    permissions :member           # permissions specify that this api can be call by which user roles of your app
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
  * [Api Doc Description](#api-doc-description)
  * [Api Description](#api-description)
    * [Header Description](#header-description)
    * [Body Description](#body-description)
    * [Response Description](#response-description)
    * [Error Description](#error-description)
      * [Error Code Description](#error-code-description)
  * [Nested Param Description](#nested-param-description)


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

The following keywords are available:

_**controller_name**_

  describe controller name or resource name of all apis in the document. For example: users, notes
  if not specified the resource name will according to the file name

_**version**_

  describe version of all apis in the document, if not specified all apis in this document will be in default version

_**api**_

  describe api by action name and provide a short description. The first parameter is action name. The second parameter is short description. The third parameter is a block of an api detail (see [Api Description](#api-description) for detail). The second and third parameter are optional.

**Example:**

```ruby
# api_doc/notes_api_doc.rb
class NotesApiDoc < ApiDoc
  controller_name :notes
  version "0.1"

  api :index, 'get all notes' do
    ...
  end
end
```


## Api Description

The following keywords are available:

_**desc**_

  full description of api

_**tags**_

  array of tag name

_**permissions**_

  array of user roles that have access to the api

_**header**_

  describe request header of api (see [Header Description](#header-description) for detail)

_**body**_

  describe request body of api (see [Body Description](#body-description) for detail)

_**response**_

  describe response body of api (see [Response Description](#response-description) for detail)

_**error**_

  describe every possible error that can happen when calling api (see [Error Description](#error-description) for detail)

**Example:**

```ruby
# api_doc/products_api_doc.rb
class ProductsApiDoc < ApiDoc
  controller_name :products
  version "0.1"

  api :index, 'get all products' do
    desc 'get all products'
    tags :mobile, :web
    permissions :admin, :member, :guest
    header do
      ...
    end
    body do
      ...
    end
    response do
      ...
    end
    error do
      ...
    end
  end
end
```


### Header Description

The following keywords are available:

_**param**_

  describe every possible parameter of request header. The first parameter is parameter name. The second parameter is type of parameter. The second parameter is require but the first one can be blank. And the following keywords are available for options:

  _**desc**_

    full description of parameter

  _**permissions**_

    array of user roles that have access to the parameter

  _**required**_

    parameter requirement, default is false

  _**default**_

    default value of parameter

  _**validates**_

    parameter validations

  _**warning**_

    warning message for parameter

  And the last part is block of an nested parameters (see [Nested Parameter Description](nested-parameter-description))

**Example:**

```ruby
# api_doc/products_api_doc.rb
class ProductsApiDoc < ApiDoc
  controller_name :products
  version "0.1"

  api :index, 'get all products' do
    desc 'get all products'
    tags :mobile, :web
    permissions :admin, :member, :guest
    header do
      param "User-Id", :string,
        desc: 'user id',
        permissions: [ :guest, :admin, :member ],
        required: true,
        default: nil,
        validates: { min: -1 }
    end
    body do
      ...
    end
    response do
      ...
    end
    error do
      ...
    end
  end
end
```


### Body Description

The following keywords are available:

_**param**_

  describe every possible parameter of request body. The first parameter is parameter name. The second parameter is type of parameter. The second parameter is require but the first one can be blank. And the following keywords are available for options:

  _**desc**_

    full description of parameter

  _**permissions**_

    array of user roles that have access to the parameter

  _**required**_

    parameter requirement, default is false

  _**default**_

    default value of parameter

  _**validates**_

    parameter validations

  _**warning**_

    warning message for parameter

  And the last part is block of an nested parameters (see [Nested Parameter Description](nested-parameter-description))

**Example:**

```ruby
# api_doc/addresses_api_doc.rb
class AddressessApiDoc < ApiDoc
  controller_name :addresses
  version "0.1"

  api :create, 'create an address' do
    desc 'create an address'
    tags :mobile, :web
    permissions :guest
    header do
      ...
    end
    body do
      param "address", :object,
        desc: 'address attributes',
        permissions: [ :guest ] do
          param :address_no, :string,
            desc: 'address number',
            permissions: [ :guest ]
          param :road, :string,
            desc: 'road',
            permissions: [ :guest ]
          param :postcode, :string,
            desc: 'postal code',
            permissions: [ :guest ]
        end
    end
    response do
      ...
    end
    error do
      ...
    end
  end
end
```


### Response Description

The following keywords are available:

_**param**_

  describe every possible parameter of response body. The first parameter is parameter name. The second parameter is type of parameter. The second parameter is require but the first one can be blank. And the following keywords are available for options:

  _**desc**_

    full description of parameter

  _**permissions**_

    array of user roles that have access to the parameter

  _**required**_

    parameter requirement, default is false

  _**default**_

    default value of parameter

  _**validates**_

    parameter validations

  _**warning**_

    warning message for parameter

  And the last part is block of an nested parameters (see [Nested Parameter Description](nested-parameter-description))

**Example:**

```ruby
# api_doc/products_api_doc.rb
class ProductsApiDoc < ApiDoc
  controller_name :products
  version "0.1"

  api :index, 'get all products' do
    desc 'get all products'
    tags :mobile, :web
    permissions :admin, :member, :guest
    header do
      ...
    end
    body do
      ...
    end
    response do
      param "", :array,
        desc: 'array of product',
        permissions: [ :guest, :admin, :member ] do
          param "product", :object,
            desc: 'product object',
            permissions: [ :guest, :admin, :member ] do
              ...
            end
        end
    end
    error do
      ...
    end
  end
end
```





