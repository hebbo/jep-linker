Rails.application.routes.draw do
  root 'links#new'

  namespace :api, defaults: {format: :json} do
    get '/links', to: 'links#index'
    post '/links', to: 'links#create'
  end

  devise_for :users

  resources :links, only: [:new, :create, :show]
  get '/:short_url', to: 'links#forward'
end
