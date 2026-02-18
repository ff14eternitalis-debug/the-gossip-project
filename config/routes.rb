Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Page d'accueil
  root "gossips#index"

  devise_for :users, controllers: { registrations: "users/registrations" }

  # Gossips + commentaires (create nested)
  resources :gossips do
    resources :comments, only: [ :create ]
  end
  resources :comments, only: [ :edit, :update, :destroy ]

  # Cities
  resources :cities, only: [ :show ]

  # Tags
  resources :tags, only: [ :show ]

  # Likes (polymorphique)
  resources :likes, only: [ :create, :destroy ]

  # Messagerie privee
  resources :conversations, only: [ :index, :show, :new, :create ]

  # Users
  resources :users, only: [ :show ]

  # Follow / Feed
  resources :follows, only: [ :create, :destroy ]
  get "/feed", to: "feed#index", as: "feed"

  # Notifications
  resources :notifications, only: [ :index ]

  # Recherche
  get "/search", to: "search#index", as: "search"

  # Admin
  namespace :admin do
    get "/", to: "dashboard#index", as: "dashboard"
  end

  # API JSON
  namespace :api do
    namespace :v1 do
      resources :gossips, only: [ :index, :show ]
      resources :users, only: [ :index, :show ]
    end
  end

  # Pages statiques
  get "/team", to: "static_pages#team"
  get "/contact", to: "static_pages#contact"
  get "/welcome/:first_name", to: "static_pages#welcome", as: "welcome"
end
