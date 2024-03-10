Rails.application.routes.draw do
  resources :pack_materials
  resources :carrier_rates
  resources :customer_ratecards
  resources :bills
  get 'dashboard/home'
  get 'sessions/new'
  post 'sessions/create'
  get 'sessions/destroy'
  get 'transport/all_bookings'
  get 'transport/container_timeslot'
  get 'transport/export_bookings'
  get 'transport/inbound'
  get 'transport/vasrecords'
  get 'order/filtered_orders'
  get 'order/export_orders', defaults: { format: :csv }
  get 'order/order_details' #, defaults: { format: :js }
  post 'order/update_order'
  post 'order/update_order_package_weight'

  resources :customers

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
      get :index, :upload_orders, :bills_orders, :get_order,:bulk_cal_packm_prices
    end
  end

  #root 'sessions#new'
  root 'dashboard#home'
end
