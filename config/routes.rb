Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # get "/launchvehicles",to: "launch_vehicles#index"
  # get "/launchvehicles/new", to:"launch_vehicles#new"
  # root "launch_vehicles#index"
  # resources :launch_vehicles
  # resources :spacecrafts
  #crud launch_vehicles
  get "/launch_vehicles/:id", to: "launch_vehicles#show"
  delete "/launch_vehicles", to: "launch_vehicles#destroy_index"
  post "launch_vehicles/mapping", to: "launch_vehicles#mapping"
  post "launch_vehicles/autopopulate", to: "launch_vehicles#bulk"
  post "launch_vehicles/new", to: "launch_vehicles#new"
  delete "/launch_vehicles/:id", to: "launch_vehicles#delete"
  patch "/launch_vehicles/:id", to: "launch_vehicles#update"
  #crud spacecrafts
  get "/spacecrafts/:id", to: "spacecrafts#show"
  delete "/spacecrafts", to: "spacecrafts#destroy_index"
  post "spacecrafts/mapping", to: "spacecrafts#mapping"
  post "spacecrafts/autopopulate", to: "spacecrafts#bulk"
  post "spacecrafts/new", to: "spacecrafts#new"
  delete "/spacecrafts/:id", to: "spacecrafts#delete"
  patch "/spacecrafts/:id", to: "spacecrafts#update"
  #queries
  get "/queries/spacecrafts_name", to: "queries#spacecrafts_name"
  get "/queries/launch_vehicles_range/:id", to: "queries#launch_vehicles_range"
  get "/queries/launch_vehicles_spacecrafts",to: "queries#launch_vehicles_spacecrafts"
  get "/queries/launch_vehicles_spacecrafts_cordinator", to: "queries#launch_vehicles_spacecrafts_cordinator"
  get "/queries/launch_vehicles_top_hits", to: "queries#launch_vehicles_top_hits"
  get "/queries/launch_vehicles_bool", to: "queries#launch_vehicles_bool"
  # Defines the root path route ("/")
  # root "articles#index"
end
