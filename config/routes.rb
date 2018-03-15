Rails.application.routes.draw do
  namespace :api do
    get '/links', to: 'links#index'
    post '/links', to: 'links#create'
  end

  devise_for :users
  root 'links#new'
  resources :links
  get '/:short_url', to: 'links#forward'
end
