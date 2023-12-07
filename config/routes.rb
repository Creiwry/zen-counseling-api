Rails.application.routes.draw do
  resources :updates

  ## Store API
  resources :users, only: [:show] do
    resources :appointments
    resources :invoices
    resource :carts, only: [:update, :show] do
      resources :cart_items, only: [:create, :update, :destroy]
    end
  end

  resources :items do
    resources :cart_items, only: [:create]
  end

  resources :orders
  resources :items

  ## Counseling API
  get '/current_user', to: 'current_user#index'
  devise_for :users, path: '/users', path_names: {
      sign_in: '/sign_in',
    },
  controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
