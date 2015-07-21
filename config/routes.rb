OneboxApiDoc::Engine.routes.draw do

  root 'application#index'
  get '/example' => 'application#example'

  get '/:tag' => 'application#index', as: :apis_by_tag
  
  get '/:version/:tag/:resource_name/:method/:url', to: 'application#show', :constraints => { version: /[^\/]+/ }, as: :api
  get '/:version/:tag/:resource_name', to: 'application#show', :constraints => { version: /[^\/]+/ }, as: :resource_name

end
