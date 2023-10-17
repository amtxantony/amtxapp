require 'cgi'
class BillsController < ApplicationController
  before_action :set_bill, only: %i[ show edit update destroy ], except: %i[vieworders]

  # GET /bills or /bills.json
  def index
    @bills = Bill.all
    # data = {
    #     "destination": {
    #       "street": "new road",
    #       "suburb": "",
    #       "city": "",
    #       "state": "",
    #       "post_code": "4211",
    #       "country_code": "AU"
    #     },
    #     "packages": [
    #       {
    #         "weight": "17"
    #       }
    #     ]
    #   }
    #starshipit_service = StarshipitService.new()
    #   rates = starshipit_service.get_rates(data)
    #   puts rates['rates'][0]

    #new_order = starshipit_service.get_order("#420_38198")
    #puts new_order    
  end

  # GET /bills/1 or /bills/1.json
  def show
  end

  def unload_orders
  end

  # GET /bills/new
  def new
    @bill = Bill.new
  end

  # GET /bills/1/edit
  def edit
  end

  # POST /bills or /bills.json
  def create
    @bill = Bill.new(bill_params)

    respond_to do |format|
      if @bill.save
        format.html { redirect_to bill_url(@bill), notice: "Bill was successfully created." }
        format.json { render :show, status: :created, location: @bill }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bills/1 or /bills/1.json
  def update
    respond_to do |format|
      if @bill.update(bill_params)
        format.html { redirect_to bill_url(@bill), notice: "Bill was successfully updated." }
        format.json { render :show, status: :ok, location: @bill }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bills/1 or /bills/1.json
  def destroy
    @bill.destroy

    respond_to do |format|
      format.html { redirect_to bills_url, notice: "Bill was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def generate_ecommerce_bills
    # initiate Starshipit Service
    starshipit_service = StarshipitService.new()

    # Process Uploaded Orders, convert into array
    order_numbers = upload(params[:excel_file])
    order_numbers_select = []
    order_numbers.each{|a| order_numbers_select << a[0] } # only need the "Order Number"

    # eliminate existing orders
    existing_order_numbers = Order.where(order_number: order_numbers_select).pluck(:order_number)

    # create orders
    order_numbers.each do |order_number|
      unless existing_order_numbers.include?(order_number[0])
        new_order = starshipit_service.get_order(order_number[0])

        rate_card = CustomerRatecard.find_by_customer_id(order_number[1])
        customer = Customer.find_by_order_no_prefix(order_number[1])

        order = Order.create!(
          their_order_id: new_order['order']['order_id'], 
          order_source: new_order['order']['reference'],
          order_date: new_order['order']['order_date'],  
          order_number: new_order['order']['order_number'],
          #code: "",
          carrier_service_code: new_order['order']['carrier_service_code'],
          #urgent: "",
          customer_id: order_number[1],
          ship_to: new_order['order']['destination']['name'],
          postcode: new_order['order']['destination']['post_code'],
          suburb: new_order['order']['destination']['suburb'],
          address: new_order['order']['destination']['street'],
          #city: new_order['order']['destination'][''],
          state: new_order['order']['destination']['state'],
          country: new_order['order']['destination']['Australia'],
          handling_fee: 0.0,
          shipping_fee: 0.0,
          billed: false
        )

        handling_fee = rate_card[:order_fee] + rate_card[:handle_out_fee]

        new_order['order']['items'].each do |order_item|
          OrderItem.create!(
            order_number: order_number[0],
            item_SKU: order_item['sku'],
            #item_barcode: order_item[''],
            quantity: order_item['quantity'],
            weight: order_item['weight'],
            item_description: order_item['description']
          )

          if order_item['weight'] <= 1
            handling_fee += rate_card[:band_1_1st]
            handling_fee += rate_card[:band_1_add] * (order_item['quantity'] - 1)
          elsif order_item['weight'] > 1 && order_item['weight'] <= 2
            handling_fee += rate_card[:band_2_1st]
            handling_fee += rate_card[:band_2_add] * (order_item['quantity'] - 1)
          elsif order_item['weight'] > 2 && order_item['weight'] <= 3
            handling_fee += rate_card[:band_3_1st]
            handling_fee += rate_card[:band_3_add] * (order_item['quantity'] - 1)
          elsif order_item['weight'] > 3 && order_item['weight'] <= 5
            handling_fee += rate_card[:band_4_1st]
            handling_fee += rate_card[:band_4_add] * (order_item['quantity'] - 1)
          elsif order_item['weight'] > 5 && order_item['weight'] <= 10
            handling_fee += rate_card[:band_5_1st]
            handling_fee += rate_card[:band_5_add] * (order_item['quantity'] - 1)
          else
            handling_fee += rate_card[:band_6_extra_per_kg] * (order_item['weight'] - 10) + rate_card[:band_6_1st]
            handling_fee += rate_card[:band_6_add] * (order_item['quantity'] - 1)
          end
        end


        shipping_fee = 0.0
        new_order['order']['packages'].each do |order_packages|
          OrderPackage.create!(
            package_id: order_packages['package_id'],
            order_number: order_number[0],
            weight: order_packages['weight'],
            length: order_packages['length'],
            width: order_packages['width'],
            height: order_packages['height']
          )
          data = {
            "destination": {
              "street": new_order['order']['destination']['street'],
              "suburb": new_order['order']['destination']['suburb'],
              "city": "",
              "state": new_order['order']['destination']['state'],
              "post_code": new_order['order']['destination']['post_code'],
              "country_code": "AU"
            },
            "packages": [
              {
                "weight": order_packages['weight']
              }
            ]
          }

          rates = starshipit_service.get_rates(data)
          if rates['success']
            #check carrier_service_code
            rates['rates'].each do |rate|
              if rate['service_code'] == new_order['order']['carrier_service_code']
                shipping_fee += rate['total_price'].to_f * (1 + PRICE_TIER[customer[:tier].to_i])
              end
            end
          end
        end

        order.update!(
            handling_fee: handling_fee,
            shipping_fee: shipping_fee
          )
      end
    end
    redirect_to :controller =>"order", :action => "bills_orders", :order_numbers => CGI.escape(order_numbers_select.join(','))
  end

  private

  def upload(excel_file)
    uploaded_file = excel_file

    if uploaded_file
      data_array = process_excel_file(uploaded_file.tempfile.path)
      # Use data_array as needed
      return data_array
    else
      render json: { error: 'No file uploaded' }
    end
  end


  def process_excel_file(file_path)
    excel = Roo::Excelx.new(file_path)
    sheet = excel.sheet(0)
    data_array = []

    sheet.each_row_streaming do |row|
      row_data = row.map(&:value)
      data_array << row_data
    end

    data_array
  end


    # Use callbacks to share common setup or constraints between actions.
    def set_bill
      @bill = Bill.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bill_params
      params.require(:bill).permit(:customer_id, :start_date, :end_date, :orders, :invoiced, :invoiced_date, :bill_type, :excel_file)
    end
end
