Rails.application.routes.draw do

  mount OneboxApiDoc::Engine => "/docs"
  # mount OneboxApiDoc::Engine => "/api_doc"

  resources :products, only: [:index, :create, :show, :update, :destroy]
  resources :users, only: [:show, :update]
  resources :orders, only: [:show, :update]
end
