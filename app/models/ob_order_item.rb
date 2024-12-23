class ObOrderItem < ApplicationRecord
	belongs_to :ob_order, primary_key: :order_no, foreign_key: :order_no

	scope :within_date_range, ->(start_date, end_date, client_id) {
	    joins(:ob_order).where(ob_orders: { conf_date: start_date..end_date, client_id: client_id })
	  }


	def self.validate_total_lines(order_no)
	    total_count = where(order_no: order_no).count

	    if total_count == 0
	    	return true
	    else
	    	return false
	    end
  	end
end
