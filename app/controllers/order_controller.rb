require 'csv'
class OrderController < ApplicationController
  before_action :to_login_if_no_session
  def index
    @orders = Order.order('order_date desc').paginate(page: params[:page], per_page: 100)
    @customers = Customer.all
  end

  def filtered_orders
    @orders = Order.where("order_date > ? and order_date < ? and customer_id = ? and status = ?", params[:dfrom], params[:dto], params[:ocustomer], params[:ostatus].to_i ).order('order_date desc')
    @customers = Customer.all
  end

  def upload_orders 
    # Order.destroy_all
    # OrderItem.destroy_all
    # OrderPackage.destroy_all   
    #puts orders.find_zone(3139)
    #Order.update_all(packm_price: -1.0) 
    # orders = Order.all
    # orders.each do |order|
    #   order.update(:customer_id => ['#420_'].find { |s| order[:order_number].include? s })
    # end                                                                        
  end

  def get_order       
  	order = Order.new
    order.get_individaul_order(params[:order_id])
    
    redirect_to :action=>"index"
  end

  def bulk_cal_packm_prices
    package_materials = PackMaterial.all
    orders = Order.where(packm_price: -1.0)
    free_pack_customer_ids = Customer.where(packm: true).pluck(:order_no_prefix)
    orders.each do |order|
      packing_materials_price = 0.0
      if order.customer_id
        unless free_pack_customer_ids.include?(order.customer_id)
          order.order_packages.each do |order_package|
              vol = order_package.length * order_package.width * order_package.height
              packing_materials_price += calculate_pack_price(vol, package_materials)
          end
        end
      end
      order.update!(packm_price: packing_materials_price)
    end
    redirect_to action: "index"
  end

  def export_orders
    orders = Order.where(id: params[:order_ids].split(','))
    respond_to do |format|
      format.csv do
        orders.each do |order|
          if order.status == ORDER_STATUS['calculated'] && order.packm_price != -1.0
            orders.update(:status => ORDER_STATUS['billed'])
          end
        end
        send_data Order.to_csv(orders.pluck(:id)),
          filename: "export_#{Time.now.to_i}.csv",
          type: 'text/csv',
          disposition: 'attachment'
      end
    end
  end


  private

  def calculate_pack_price(vol, package_materials)
    package_vols = package_materials.pluck(:maxcube)
    i = package_vols.find_index(find_closest_number(vol, package_vols))
    return package_materials[i].price
  end

  def find_closest_number(target_number, decimal_array)
    valid_numbers = decimal_array.select { |num| num >= target_number }
    closest_number = valid_numbers.max_by { |num| target_number - num }
    closest_number
  end
end
