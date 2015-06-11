Rails.application.routes.draw do

  mount OneboxApiDoc::Engine => "/docs"
end
