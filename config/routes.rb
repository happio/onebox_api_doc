OneboxApiDoc::Engine.routes.draw do

  root 'application#index'

  get '/:version/:resource_name/:action_name', to: 'application#index', :constraints => { version: /[^\/]+/ }
  get '/:version/:resource_name', to: 'application#index', :constraints => { version: /[^\/]+/ }

end
