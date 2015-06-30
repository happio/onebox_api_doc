class UsersApiDoc < OneboxApiDoc::ApiDoc
  controller_name :users
  version "1.6.0"
  
  api :show, 'get user profile' do
    desc 'get user profile'
    tags :mobile, :web
    permissions :admin, :member
    request do
      header do
        param "User-id", :string, 
          desc: 'user id',
          permissions: [ :member ],
          required: true
        param "User-type", :string, 
          desc: 'user type',
          permissions: [ :member ],
          required: true
        param "Authentication", :string, 
          desc: 'user token',
          permissions: [ :member ],
          required: true
      end
      body do
        param :body_param_1, :string, 
          desc: 'body_param_1 desc',
          permissions: [ :guest, :admin, :member ],
          required: true,
          default: 'body_param_1 default',
          validates: {
            min: -1,
            max: 10,
            within: [:a, :b],
            pattern: "",
            email: true
          },
          warning: "body_param_1 warning" do
            # param
            ;
          end
      end
    end
    response do
      body do
        param :response_param_1, :string, 
          desc: 'response_param_1 desc',
          permissions: [ :guest, :admin, :member ],
          validates: {
            min: -1,
            max: 10,
            within: [:a, :b],
            pattern: "",
            email: true
          },
          warning: "response_param_1 warning" do
            # param
            ;
          end
      end
    end
    error do
      code 404, "" do
        permissions :guest, :admin, :member
        param :error_code_param_1, :string, 
          desc: '',
          permissions: [ :guest, :admin, :member ]
      end
    end
  end

  api :update, 'update user profile' do
    desc 'update user profile'
    tags :mobile, :web
    permissions :member
    request do
      header do
        param "User-id", :string, 
          desc: 'user id',
          permissions: [ :member ],
          required: true
        param "User-type", :string, 
          desc: 'user type',
          permissions: [ :member ],
          required: true
        param "Authentication", :string, 
          desc: 'user token',
          permissions: [ :member ],
          required: true
      end
      body do
        param :first_name, :string, 
          desc: 'user first name',
          permissions: [ :member ],
          required: true
        param :last_name, :string, 
          desc: 'user first name',
          permissions: [ :member ],
          required: true
      end
    end
    response do
      body do
        param :first_name, :string, 
          desc: 'user first name',
          permissions: [ :member ]
        param :last_name, :string, 
          desc: 'user first name',
          permissions: [ :member ]
      end
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
end