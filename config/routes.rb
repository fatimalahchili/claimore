Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :claims do
    collection do
      get :timeline
    end
    resources :letters, only: %i[new create]
  end
  resources :letters, only: %i[show destroy]

  resources :properties, only: [:new, :show, :create, :update, :destroy]
  resources :chats, only: [:new, :create, :destroy]
  resources :entries, except: %i[show index]
  resources :templates
  resources :contacts
  resources :tenants

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check
end

