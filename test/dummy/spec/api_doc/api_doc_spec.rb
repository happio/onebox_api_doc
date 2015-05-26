require "rails_helper"

module OneboxApiDoc
  describe ApiDoc do

    class TestApiDoc < ApiDoc
      controller_name :products
      version "1.2.3"

      api :show, 'short_desc' do
        desc 'description'
        tags :mobile, :web
        permissions :guest, :admin, :member
        header do
          param :name, :string, 
            desc: '',
            permissions: [ :guest, :admin, :member ],
            required: true,
            default: 'eiei',
            validates: {
              min: -1,
              max: 10,
              within: [:a, :b],
              pattern: "",
              email: true
            },
            warning: "header warning" do
              # param
              ;
            end
        end
        body do
          param :name, :string, 
            desc: '',
            permissions: [ :guest, :admin, :member ],
            required: true,
            default: 'eiei',
            validates: {
              min: -1,
              max: 10,
              within: [:a, :b],
              pattern: "",
              email: true
            },
            warning: "body warning" do
              # param
              ;
            end
        end
        response do
          param :name, :string, 
            desc: '',
            permissions: [ :guest, :admin, :member ],
            required: true,
            default: 'eiei',
            validates: {
              min: -1,
              max: 10,
              within: [:a, :b],
              pattern: "",
              email: true
            },
            warning: "response warning" do
              # param
              ;
            end
        end
        error do
          code 404, "" do
            permissions [:guest, :admin, :member]
            param :name, :string, 
              desc: '',
              permissions: [ :guest, :admin, :member ] do
                ;
              end
          end
        end
      end
    end

    it "set controller name and version to doc" do
      expect(TestApiDoc._controller_name).to eq "products"
      expect(TestApiDoc._version).to eq "1.2.3"
    end

    it "set correct api detail" do
      expect(TestApiDoc._apis).not_to be_blank
      api = TestApiDoc._apis.first
      expect(api._action).to eq "show"
      expect(api._short_desc).to eq "short_desc"
      expect(api._url).to eq "/products/:id"
      expect(api._method).to eq "GET"
      expect(api._desc).to eq "description"
      expect(api._tags).to eq [:mobile, :web]
      expect(api._permissions).to eq [:guest, :admin, :member]
      expect(api._header).to be_a OneboxApiDoc::Api::Header
      expect(api._body).to be_a OneboxApiDoc::Api::Body
      expect(api._response).to be_a OneboxApiDoc::Api::Response
      expect(api._error).to be_a OneboxApiDoc::Api::Error
    end

  end
end