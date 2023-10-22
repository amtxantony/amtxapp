class Order < ApplicationRecord
	has_many :order_items, :primary_key =>"order_number", :foreign_key => "order_number", :class_name => "OrderItem"
	has_many :order_packages, :primary_key =>"order_number", :foreign_key => "order_number", :class_name => "OrderPackage"


	def fetch_new_shipped_orders
		last_order = Order.last
		starshipit_service = StarshipitService.new()
		if last_order
	    	orders = starshipit_service.fetch_shipped_orders(last_order.order_date)
	    else
	    	orders = starshipit_service.fetch_shipped_orders(0)
	    end

	    customer_prefixes = Customer.all.pluck(:order_no_prefix)

	    if orders
		    orders['orders'].each do |order|
		    	unless Order.exist(:order_number => order['order_number'])
		    		Order.create!(
			          their_order_id: order['order_id'], 
			          order_source: order['reference'],
			          order_date: order['order_date'],  
			          order_number: order['order_number'],
			          carrier_service_code: ['carrier_service_code'],
			          customer_id: customer_prefixes.find { |s| order['order_number'].include? s },
			          handling_fee: 0.0,
			          shipping_fee: 0.0,
			          status: ORDER_STATUS['fetched']
			        )
		    	end
		    end
		end
  	end

  	def get_individaul_order
  		order = Order.where(:status => ORDER_STATUS['fetched']).first
  		starshipit_service = StarshipitService.new()
  		if order 			
  			new_order = starshipit_service.get_order(order.order_number)
			rate_card = CustomerRatecard.find_by_customer_id(order.customer_id)
        	customer = Customer.find_by_order_no_prefix(order.customer_id)

	        order.update(
	          ship_to: new_order['order']['destination']['name'],
	          postcode: new_order['order']['destination']['post_code'],
	          suburb: new_order['order']['destination']['suburb'],
	          address: new_order['order']['destination']['street'],
	          #city: new_order['order']['destination'][''],
	          state: new_order['order']['destination']['state'],
	          country: new_order['order']['destination']['Australia']
	        )

	        handling_fee = rate_card[:order_fee] + rate_card[:handle_out_fee]

	        new_order['order']['items'].each do |order_item|
				OrderItem.create!(
					order_number: order.order_number,
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
	        new_order['order']['packages'].each do |order_package|
				order_package = OrderPackage.create!(
					package_id: order_package['package_id'],
					order_number: order_number[0],
					weight: order_package['weight'],
					length: order_package['length'],
					width: order_package['width'],
					height: order_package['height']
				)
				i = 0
				WEIGHT_RANGE.each do |weight|
					if order_package.weight >= weight['low'] && order_package.weight <= weight['high']
					  order_package.update!(
					      weight_band: i
					    )
					end
					i += 1
        		end

        		carrier_rate = CarrierRate.where(:weight_band => order_package.weight_band, :zone => find_zone(order.postcode), :carrier_product_code => order.carrier_service_code).first
        		shipping_fee += carrier_rate.rate * (1 + PRICE_TIER[customer[:tier].to_f])
  			end

  			order.update!(
	            handling_fee: handling_fee,
	            shipping_fee: shipping_fee,
	            status: ORDER_STATUS['calculated']
	          )
  		end
  	end


  	def find_zone(postcode)
	  zone = nil

	  # Iterate through each entry in the zone array
	  POST_ZONE.each do |entry|
	    postcodes = entry['postcodes']

	    # Check if the given postcode is in the range for the current entry
	    if postcodes.include?(postcode)
	      zone = entry['zone']
	      break
	    end
	  end

	  return zone
	end

end
