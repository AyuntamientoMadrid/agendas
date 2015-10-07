Rails.application.routes.draw do

  root to: 'visitors#index'
  get "/activities", to: 'visitors#search', as: 'search'
  get '/activities/:id', to: 'visitors#show', as: 'show'
  get '/update_areas', to: 'visitors#update_areas', as: 'update_areas'
  get '/update_holders', to: 'visitors#update_holders', as: 'update_holders'

  # Admin
  get "/admin", to: 'users#index', as: 'admin'
  devise_for :users, controllers: { session: "users/sessions", registration: "users/registration" }

  resources :users do
    collection do
      get :search
      post :search

    end
  end
  resources :events







  resources :holders do
    collection do
      get :search
      post :search

    end
  end

end
