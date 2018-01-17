Rails.application.routes.draw do

  # Public resources
  root to: 'homepage#index'
  get '/lang/:lang', to: 'application#change_language', as: 'change_language'
  get '/show/:id', to: 'visitors#show', as: 'show'
  get '/update_holders', to: 'visitors#update_holders', as: 'update_holders'
  get '/inicio.do', to: 'uweb_access#uweb_sign_in'
  get '/agenda/:holder/:full_name', to: 'visitors#agenda', as: 'agenda'

  get '/faq', to: 'questions#index', as: 'faq'
  get '/websitemap', to: 'static_pages#websitemap', as: 'websitemap'

  resources :statistics, only: [:index]

  get '/code_of_conduct', to: 'static_pages#code_of_conduct', as: 'code_of_conduct'
  get '/accessibility', to: 'static_pages#accessibility', as: 'accessibility'

  get '/homepage', to: 'homepage#index', as: 'homepage'
  get 'registration_lobbies/index'
  get '/registration_lobbies', to: 'registration_lobbies#index', as: 'registration_lobbies'
  get '/visitors', to: 'visitors#index', as: 'visitors'

  # Admin
  get "/admin", to: 'events#index', as: 'admin'

  devise_for :users, controllers: { sessions: "users/sessions" }

  resources :events
  resources :areas
  resources :activities
  resources :infringement_emails, only: [:new, :create]
  resources :holders

  namespace :admin do
    resources :users
    get 'passwords/edit', to: 'passwords#edit', as: 'edit_password'
    match 'passwords/update', to: 'passwords#update', as: 'update_password', via: [:patch, :put]
    resources :organizations do
      resources :agents, except: :show
      resources :organization_interests, only: [:index]
      match 'interests_update', to: 'organization_interests#update', as: 'interests_update', via: [:patch, :put]
    end
    resources :questions
    post 'order_questions', to: 'questions#order', as: 'order_questions'
  end

  resources :positions do
    get :autocomplete_position_title, :on => :collection
  end
  get '/organizations/edit', to: 'organizations#edit', as: 'edit_organization'
  get '/organizations/destroy', to: 'organizations#destroy', as: 'destroy_organization'
  get '/organizations/new', to: 'organizations#new', as: 'new_organization'
  resources :organizations, except: [:new, :edit, :destroy] do
    get :autocomplete_organization_name, :on => :collection
    resources :represented_entities, only: :index, format: :json
    resources :agents, only: :index, format: :json
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

end
