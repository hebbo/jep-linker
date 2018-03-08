Rails.application.routes.draw do
  namespace :api do
    get '/links', to: 'links#index'
  end

  devise_for :users
  root 'links#new'
  resources :links
  get '/:short_url', to: 'links#forward'
end
