OneboxApiDoc::Engine.routes.draw do

  root 'application#index'
  get '/example' => 'application#example'
  
  get '/:version/:resource_name/:action_name', to: 'application#show', :constraints => { version: /[^\/]+/ }, as: :action
  get '/:version/:resource_name', to: 'application#show', :constraints => { version: /[^\/]+/ }, as: :resource_name

end
