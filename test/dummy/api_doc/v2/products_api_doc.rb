module V2
  class ProductsApiDoc < BaseV2ApiDoc
    version "2.0.0"
    resource_name :products
    
    get '/products', 'get all products' do
      desc 'get all products'
      tags :web
      permissions :guest
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
                permissions: [ :guest ]
              param :name, :string, 
                desc: 'product name',
                permissions: [ :guest ]
              param :description, :string, 
                desc: 'product description',
                permissions: [ :guest ]
              param :status, :string, 
                desc: 'product status (online or offline)',
                permissions: [ :guest ],
                validates: {
                  within: ["online", "offline"]
                }
            end
        end
      end
    end

    post '/products', 'create a product' do
      desc 'create a product'
      tags :web
      permissions :guest
      request do
        header do
          param "User-id", :string, 
            desc: 'guest user id',
            permissions: [ :guest ],
            required: true
          param "User-type", :string, 
            desc: 'guest user type',
            permissions: [ :guest ],
            required: true
          param "Authentication", :string, 
            desc: 'guest token',
            permissions: [ :guest ],
            required: true
        end
        body do
          param :id, :integer, 
            desc: 'product id',
            permissions: [ :guest ],
            required: true,
            validates: {
              min: 1
            }
          param :name, :string, 
            desc: 'product name',
            permissions: [ :guest ]
          param :description, :string, 
            desc: 'product description',
            permissions: [ :guest ]
          param :status, :string, 
            desc: 'product status (online or offline)',
            permissions: [ :guest ],
            validates: {
              within: ["online", "offline"]
            }
        end
      end
      response do
        body do
          param :name, :string, 
            desc: 'product name',
            permissions: [ :guest ]
          param :description, :string, 
            desc: 'product description',
            permissions: [ :guest ]
          param :status, :string, 
            desc: 'product status (online or offline)',
            permissions: [ :guest ]
        end
      end
      error do
        code 404, "Not Found" do
          permissions :guest, :guest, :guest
          param :error_message, :string, 
            desc: 'error message',
            permissions: [ :guest, :guest, :guest ]
        end
      end
    end
  end
end