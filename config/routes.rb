OneboxApiDoc::Engine.routes.draw do

  root 'application#index'  
  get '/example' => 'application#example'
  get '/:tag' => 'application#index', as: :apis_by_tag
  get '/:version/:tag/:resource_name/:method/:url', to: 'application#show', :constraints => { version: /[^\/]+/ }, as: :api
  # get '/:version/:tag/:resource_name', to: 'application#show', :constraints => { version: /[^\/]+/ }, as: :resource_name
  if OneboxApiDoc::Engine.auth_service.to_s.to_sym == :devise
    devise_for :developers, class_name: "OneboxApiDoc::Developer", module: :devise 
  end

end

Rails.application.routes.draw do
  get '/developers/sign_in', redirect_to: '/docs/developers/sign_in'
end
