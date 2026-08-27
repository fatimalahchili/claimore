Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  resources :claims do
    collection do
      get :timeline
    end
    resources :letters, only: %i[new create]
  end
  resources :letters, only: %i[show destroy]

  resources :properties, only: %i[new show create update destroy] do
    resources :tenants, only: %i[index]
  end
  resources :chats, only: %i[new create destroy show] do
    resources :messages, only: %i[create]
  end
  resources :entries
  resources :templates, only: %i[show index]
  resources :contacts
  resources :tenants, only: %i[new create edit update destroy]
end
