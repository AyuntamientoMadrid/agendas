Rails.application.routes.draw do

  root to: 'visitors#index'
  get '/lang/:lang', to: 'application#change_language', as: 'change_language'
  get "/activities", to: 'visitors#search', as: 'search'
  get '/activities/:id', to: 'visitors#show', as: 'show'
  get '/update_areas', to: 'visitors#update_areas', as: 'update_areas'
  get '/update_holders', to: 'visitors#update_holders', as: 'update_holders'
  get '/contact', to: 'visitors#contact', as: 'contact'

  # Admin
  get "/admin", to: 'events#index', as: 'admin'

  devise_for :users, controllers: { session: "users/sessions", registration: "users/registration" }

  resources :users

  resources :events do
    get :autocomplete_holder_first_name, on: :collection
  end

  resources :holders

  resources :areas

end
