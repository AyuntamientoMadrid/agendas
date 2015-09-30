Rails.application.routes.draw do

  root to: 'visitors#index'

  resources :visitors
  devise_for :users, controllers: { session: "users/sessions", registration: "users/registration" }

  resources :users
  resources :holders
  resources :events

  get "/admin", to: 'users#index', as: 'admin'
  get "/search", to: 'visitors#search', as: 'search'
  get '/detail/:id', to: 'visitors#show', as: 'detail'

end
