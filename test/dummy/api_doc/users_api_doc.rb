class UsersApiDoc < OneboxApiDoc::ApiDoc
  controller_name :users
  version "1.2.3"

  api :show, 'short_desc' do
    desc 'description'
    tags :mobile, :web
    permissions :guest, :admin, :member
    header do
      param :header_param1, :string, 
        desc: 'header_param1 desc',
        permissions: [ :guest, :admin, :member ],
        required: true,
        default: 'header_param1 default',
        validates: {
          min: -1,
          max: 10,
          within: ["a", "b"],
          pattern: "header_param1 pattern",
          email: true,
          min_length: 6,
          max_length: 10
        },
        warning: "header_param1 warning" do
          param :header_param1_1, :integer, 
            desc: 'header_param1_1 desc',
            permissions: [ :guest, :member ],
            required: false,
            default: 'header_param1_1 default',
            validates: {
              min: 5,
              max: 15,
              within: ["c", "d", "e"],
              pattern: "header_param1_1 pattern",
              email: false,
              min_length: 4,
              max_length: 6
            } do
              # param
              ;
            end
        end
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
    response do
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
    error do
      code 404, "" do
        permissions [:guest, :admin, :member]
        param :error_code_param_1, :string, 
          desc: '',
          permissions: [ :guest, :admin, :member ] do
            ;
          end
      end
    end
  end
end