Rails.application.routes.draw do
  resources :carrier_rates
  resources :customer_ratecards
  resources :bills
  get 'dashboard/home'
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  get 'transport/all_bookings'
  get 'transport/container_timeslot'
  get 'transport/export_bookings'

  resources :customers
  resources :sessions, only: [:new, :create, :destroy]

  resources :sessions, only: [:new, :create, :destroy]
  resources :users
  #root 'users#index'


  resources :dashboard, only: [:home]

  resources :bills do
    collection do
      post :generate_ecommerce_bills
      #get :vieworders, :unload_orders
    end
  end

  resources :order do
    collection do
      #post :generate_ecommerce_bills
      get :index, :upload_orders, :bills_orders, :get_order
    end
  end

  root 'sessions#new'
  #root 'dashboard#home'
end
