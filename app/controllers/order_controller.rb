class OrderController < ApplicationController
  def index
    @orders = Order.order('id desc').paginate(page: params[:page], per_page: 100)
  end

  def upload_orders
  end
end
