Rails.application.routes.draw do

  mount OneboxApiDoc::Engine => "/onebox_api_doc"

  resources :products, only: [:show]
end
