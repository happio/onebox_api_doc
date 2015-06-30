class ProductsApiDoc < OneboxApiDoc::ApiDoc
  controller_name :products
  version "1.6.0"

  api :index, 'get all products' do
    desc 'get all products'
    tags :mobile
    permissions :admin, :member, :guest
    request do
      header do
      end
      body do
      end
    end
    response do
      body do
        param "", :array,
          desc: "array of product" do
            param :id, :integer, 
              desc: 'product id',
              permissions: [ :admin, :member, :guest ]
            param :name, :string, 
              desc: 'product name',
              permissions: [ :admin, :member, :guest ]
            param :description, :string, 
              desc: 'product description',
              permissions: [ :admin, :member, :guest ]
            param :status, :string, 
              desc: 'product status (online or offline)',
              permissions: [ :admin ],
              validates: {
                within: ["online", "offline"]
              }
          end
      end
    end
  end

  api :create, 'create a product' do
    desc 'create a product'
    tags :mobile, :web
    permissions :admin
    request do
      header do
        param "User-id", :string, 
          desc: 'admin user id',
          permissions: [ :admin ],
          required: true
        param "User-type", :string, 
          desc: 'admin user type',
          permissions: [ :admin ],
          required: true
        param "Authentication", :string, 
          desc: 'admin token',
          permissions: [ :admin ],
          required: true
      end
      body do
        param :id, :integer, 
          desc: 'product id',
          permissions: [ :admin ],
          required: true,
          validates: {
            min: 1
          }
        param :name, :string, 
          desc: 'product name',
          permissions: [ :admin ]
        param :description, :string, 
          desc: 'product description',
          permissions: [ :admin ]
        param :status, :string, 
          desc: 'product status (online or offline)',
          permissions: [ :admin ],
          validates: {
            within: ["online", "offline"]
          }
      end
    end
    response do
      body do
        param :name, :string, 
          desc: 'product name',
          permissions: [ :admin ]
        param :description, :string, 
          desc: 'product description',
          permissions: [ :admin ]
        param :status, :string, 
          desc: 'product status (online or offline)',
          permissions: [ :admin ]
      end
    end
    error do
      code 404, "Not Found" do
        permissions :guest, :admin, :member
        param :error_message, :string, 
          desc: 'error message',
          permissions: [ :guest, :admin, :member ]
      end
    end
  end

  api :show, 'get product' do
    desc 'get a specify product'
    tags :mobile, :web
    permissions :guest, :admin, :member
    request do
      header do
      end
      body do
        param :id, :integer, 
          desc: 'product id',
          permissions: [ :guest, :admin, :member ],
          required: true,
          validates: {
            min: 1
          }
      end
    end
    response do
      body do
        param :name, :string, 
          desc: 'product name',
          permissions: [ :guest, :admin, :member ]
        param :description, :string, 
          desc: 'product description',
          permissions: [ :guest, :admin, :member ]
        param :status, :string, 
          desc: 'product status (online or offline)',
          permissions: [ :admin ]
      end
    end
    error do
      code 404, "Not Found" do
        permissions :guest, :admin, :member
        param :error_message, :string, 
          desc: 'error message',
          permissions: [ :guest, :admin, :member ]
      end
    end
  end

  api :update, 'update product' do
    desc 'update a specify product'
    tags :mobile, :web
    permissions :admin
    request do
      header do
        param "User-id", :string, 
          desc: 'admin user id',
          permissions: [ :admin ],
          required: true
        param "User-type", :string, 
          desc: 'admin user type',
          permissions: [ :admin ],
          required: true
        param "Authentication", :string, 
          desc: 'admin token',
          permissions: [ :admin ],
          required: true
      end
      body do
        param :id, :integer, 
          desc: 'product id',
          permissions: [ :admin ],
          required: true,
          validates: {
            min: 1
          }
        param :name, :string, 
          desc: 'product name',
          permissions: [ :admin ]
        param :description, :string, 
          desc: 'product description',
          permissions: [ :admin ]
        param :status, :string, 
          desc: 'product status (online or offline)',
          permissions: [ :admin ],
          validates: {
            within: ["online", "offline"]
          }
      end
    end
    response do
      body do
        param :name, :string, 
          desc: 'product name',
          permissions: [ :admin ]
        param :description, :string, 
          desc: 'product description',
          permissions: [ :admin ]
        param :status, :string, 
          desc: 'product status (online or offline)',
          permissions: [ :admin ]
      end
    end
    error do
      code 404, "Not Found" do
        permissions :admin
        param :error_message, :string, 
          desc: 'error message',
          permissions: [ :admin ]
      end
    end
  end

  api :destroy, 'delete product' do
    desc 'delete a specify product'
    tags :mobile, :web
    permissions :admin
    request do
      header do
        param "User-id", :string, 
          desc: 'admin user id',
          permissions: [ :admin ],
          required: true
        param "User-type", :string, 
          desc: 'admin user type',
          permissions: [ :admin ],
          required: true
        param "Authentication", :string, 
          desc: 'admin token',
          permissions: [ :admin ],
          required: true
      end
      body do
      end
    end
    response do
      body do
        param :success, :boolean, 
          desc: 'success or not',
          permissions: [ :admin ]
      end
    end
    error do
      code 404, "Not Found" do
        permissions :admin
        param :error_message, :string, 
          desc: 'error message',
          permissions: [ :admin ]
      end
    end
  end

end