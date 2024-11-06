# config/routes.rb
Rails.application.routes.draw do
    # User authentication routes
    post '/signup', to: 'authentication#signup'
    post '/login', to: 'authentication#login'
    post 'checkout', to: 'carts#checkout'
    get '/cart', to: 'carts#index'

    # Product routes (some are admin-only)
    resources :products, only: [:index, :create, :update, :destroy]
    resources :carts, only: [:create]
end