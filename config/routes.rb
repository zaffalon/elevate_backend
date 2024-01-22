Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  devise_for :users, skip: :all
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    # resources :users, only: [:create]
    resource :user
    # get 'user', to: 'users#show'
    # post 'user', to: 'users#create'
    scope :user do
      resources :game_events, only: [:create]
    end
    resources :sessions, only: [:create]
    resources :games, only: [:index]
  end
end
