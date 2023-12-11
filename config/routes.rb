Rails.application.routes.draw do
  get '/current_user', to: 'current_user#index'
  get '/is_admin', to: 'current_user#admin?'
  devise_for :users, path: '/users', path_names: {
      sign_in: '/sign_in',
    },
  controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    }

  resources :updates

  ## Store API
  patch '/cart/cart_items/:id', to: 'cart_items#update'
  delete '/cart/cart_items/:id', to: 'cart_items#destroy'
  get '/cart', to: 'carts#show'
  resources :users, only: [:show] do
    resources :orders
    resources :invoices do
      resources :appointments
    end
  end

  resources :items do
    resources :cart_items, only: [:create]
  end
  resources :orders, only: [:index, :show]

  resources :items

  ## Counseling API
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
