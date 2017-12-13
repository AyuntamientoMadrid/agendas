Rails.application.routes.draw do

  # Public resources
  root to: 'visitors#index'
  get '/lang/:lang', to: 'application#change_language', as: 'change_language'
  get '/show/:id', to: 'visitors#show', as: 'show'
  get '/update_holders', to: 'visitors#update_holders', as: 'update_holders'
  get '/inicio.do', to: 'uweb_access#uweb_sign_in'
  get '/agenda/:holder/:full_name', to: 'visitors#agenda', as: 'agenda'
  get '/import', to: 'users#import', as: 'import'
  get '/faq', to: 'questions#index', as: 'faq'

  # Admin
  get "/admin", to: 'events#index', as: 'admin'

  devise_for :users, controllers: { session: "users/sessions" }
  get 'admin/edit_password', to: 'admin/passwords#edit', as: 'edit_password'
  match 'admin/update_password', to: 'admin/passwords#update', as: 'update_password', via: [:patch, :put]

  resources :users

  resources :events

  resources :holders

  resources :areas

  resources :activities

  namespace :admin do
    resources :organizations
    resources :questions
    post 'order_questions', to: 'questions#order', as: 'order_questions'
  end

  get '/organizations/edit', to: 'organizations#edit', as: 'edit_organization'
  get '/organizations/destroy', to: 'organizations#destroy', as: 'destroy_organization'
  get '/organizations/new', to: 'organizations#new', as: 'new_organization'
  resources :organizations, except: [:new, :edit, :destroy] do
    get :autocomplete_organization_name, :on => :collection
    resources :represented_entities, only: :index, format: :json
    resources :agents, only: :index, format: :json
  end

end
