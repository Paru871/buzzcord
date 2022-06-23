Rails.application.routes.draw do
  root to: 'ranks#index'
  get 'welcome', to: 'welcome#index', as: 'welcome'
  get '/auth/:provider/callback' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'
end
