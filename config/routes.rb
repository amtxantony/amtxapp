Rails.application.routes.draw do
  resources :bills
  get 'dashboard/home'
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'

  resources :customers
  resources :sessions, only: [:new, :create, :destroy]
  resources :dashboard, only: [:home]
  # resources :orders do
  #   collection do
  #     post 'sync_orders'
  #     get 'generate_excel_report'
  #   end
  # end

  #root 'sessions#new'
  root 'dashboard#home'
end
