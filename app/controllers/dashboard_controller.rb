class DashboardController < ApplicationController
  def home
    api_key = STARSHIPIT_KEY
    sub_key = STARSHIPIT_SUBSCRIPTION_KEY
    starshipit_service = StarshipitService.new(api_key, sub_key)
    orders_data = starshipit_service.fetch_shipped_orders

    orders_data.each do |order_data|
      puts order_data['order_number']

      # Order.create!(
      #   order_number: order_data['order_number'],
      #   customer_name: order_data['customer']['name'],
      #   total_amount: order_data['total_amount']
      # )
    end

  end

  def sync_orders
    api_key = ENV['STARSHIPIT_KEY']
    starshipit_service = StarshipitService.new(api_key)
    orders_data = starshipit_service.fetch_shipped_orders

    orders_data.each do |order_data|
      Order.create!(
        order_number: order_data['order_number'],
        customer_name: order_data['customer']['name'],
        total_amount: order_data['total_amount']
      )
    end

    redirect_to orders_path, notice: 'Orders synchronized successfully!'
  end
end
