Rails.application.routes.draw do

  mount OneboxApiDoc::Engine => '/docs'
  devise_for :developers, class_name: "OneboxApiDoc::Developer"

  resources :products, only: [:index, :create, :show, :update, :destroy]
  resources :users, only: [:show, :update]
  resources :orders, only: [:show, :update]
end
