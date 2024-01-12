# frozen_string_literal: true

Rails.application.routes.draw do
  get '/users', to: 'users#index'
  get '/users/:id', to: 'users#show'
  get '/users/profile', to: 'users#profile'

  get '/current_user', to: 'current_user#index'
  devise_for :users, path: '/users', path_names: {
                                       sign_in: '/sign_in'
                                       # log_out: '/log_out'
                                     },
                     controllers: {
                       sessions: 'users/sessions',
                       registrations: 'users/registrations'
                     }
  resources :updates

  ## Counselling API
  scope module: 'counselling' do
    resources :private_messages, only: %i[show destroy]
    resources :users, only: [:show] do
      resources :private_messages, only: %i[index create]
      resources :appointments, except: %i[create]
      resources :invoices
    end
  end

  # Appointments
  get '/confirmed_appointments', to: 'counselling/appointments#confirmed_appointments'
  get '/pending_appointments', to: 'counselling/appointments#index_pending_confirmation'
  get '/available_appointment', to: 'counselling/appointments#available_appointment'
  get '/users/:user_id/appointments/by_date/:appointment_date', to: 'counselling/appointments#index_by_date'

  # Invoices
  get '/invoices/:invoice_id/download_pdf', to: 'counselling/invoices#download_pdf'
  post '/invoices/:invoice_id/create_checkout_session', to: 'counselling/checkout#create'
  get '/invoices/:invoice_id/session-status', to: 'counselling/checkout#session_status'

  # Users
  get '/my_chats', to: 'counselling/private_messages#list_chats'
  get '/index_admins', to: 'users#index_admins'

  ## Store API
  scope module: 'store' do
    resources :users, only: [:show] do
      resources :orders
    end
    resources :items do
      resources :cart_items, only: [:create]
    end
    resources :orders, only: %i[index show]
  end

  patch '/cart/cart_items/:id', to: 'store/cart_items#update'
  delete '/cart/cart_items/:id', to: 'store/cart_items#destroy'
  get '/cart', to: 'store/carts#show'
  post '/orders/:order_id/create_checkout_session', to: 'store/checkout#create'
  get '/orders/:order_id/session-status', to: 'store/checkout#session_status'

  ## Counseling API
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
