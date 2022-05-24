Rails.application.routes.draw do
  get 'ranks/index'
  get 'auth/:provider/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  root 'homes#top'
end
