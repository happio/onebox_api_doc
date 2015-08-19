module ApiDoc2
  module V2
    class BankAccountsApiDoc < BaseV2ApiDoc
      version "2.0.0"
      resource_name :bank_accounts

      get '/bank_accounts', 'get all bank_accounts' do
        desc 'get all bank_accounts'
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
              desc: "array of bank account" do
                param :id, :integer, 
                  desc: 'bank account id',
                  permissions: [ :guest ]
                param :name, :string, 
                  desc: 'bank account name',
                  permissions: [ :guest ]
                param :bank, :string, 
                  desc: 'bank account bank',
                  permissions: [ :guest ]
                param :type, :string, 
                  desc: 'bank account type',
                  permissions: [ :guest ]
              end
          end
        end
      end
    end
  end
end