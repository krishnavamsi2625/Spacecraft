Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # get "/launchvehicles",to: "launch_vehicles#index"
  # get "/launchvehicles/new", to:"launch_vehicles#new"
  root "launch_vehicles#index"
  resources :launch_vehicles
  resources :satellites
  # Defines the root path route ("/")
  # root "articles#index"
end
