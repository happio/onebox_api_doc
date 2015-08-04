Rails.application.routes.draw do

  mount OneboxApiDoc::Engine => "/docs"
  resources :products, only: [:index, :create, :show, :update, :destroy]
  resources :users, only: [:show, :update]
  resources :orders, only: [:show, :update]
end
