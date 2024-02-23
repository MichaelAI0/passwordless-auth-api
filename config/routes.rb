Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      post "auth/login", to: "authentication#create"
      post "auth/magic_link", to: "sessions#create"
      resources :contracts, only: :show 
    end
  end
end
