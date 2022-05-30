Rails.application.routes.draw do
  root to: 'ranks#index'
  get 'homes', to: 'homes#top', as: 'homes'
  get '/auth/:provider/callback' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'
end
