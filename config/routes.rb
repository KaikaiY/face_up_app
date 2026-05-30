Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "problems#index"

  get "units/:unit", to: "problems#unit", as: :unit_problems

  resources :practice_sessions, only: %i[show create] do
    post :check, on: :member
    post :record, on: :member
  end

  resources :problems, only: %i[index show]
  resources :attempts, only: %i[index show create] do
    post :check, on: :collection
  end
end
