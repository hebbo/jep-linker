Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  post "/", to: "home#create"

  namespace :api do
    get '/status', to: 'status#health'
  end
end
