class OrderController < ApplicationController
  before_action :to_login_if_no_session
  def index
    @orders = Order.order('id desc').paginate(page: params[:page], per_page: 100)
  end

  def upload_orders 
    # Order.destroy_all
    # OrderItem.destroy_all
    # OrderPackage.destroy_all                                                                             
  end

  def get_order
  	#starshipit_service = StarshipitService.new()
    #starshipit_service.fetch_shipped_orders(0)        
  	#@order = starshipit_service.get_order(params[:order_number])
    # orders = Order.new
    # orders.fetch_new_shipped_orders
    #orders.get_individaul_order
    #puts orders.find_zone(3139)
  end



  def bills_orders
  	respond_to do |format|
      format.xlsx {
        xlsx_package = Axlsx::Package.new
        wb = xlsx_package.workbook

        wb.add_worksheet(name: 'Shipped Orders') do |sheet|
          sheet.add_row ['Order Number', 'Customer Prefix', 'Billed?','Postcode','Handling Fee','Shipping Fee'] # Customize with your column names

          orders.each do |item|
            sheet.add_row [item.order_number, item.customer_id, item.billed, item.postcode, item.handling_fee, item.shipping_fee] # Adjust with your actual column names
            order.update!(
              billed: true
            )
          end
        end

        send_data xlsx_package.to_stream.read, filename: "Shipped_Orders_#{DateTime.now().to_s}.xlsx", type: 'application/xlsx', disposition: 'attachment'
      }
    end

  end
end
