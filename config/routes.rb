Rails.application.routes.draw do
  resources :order_items
  resources :cart_items
  resources :items
  resources :carts
  resources :orders
  resources :appointments
  resources :invoices
  resources :updates
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
