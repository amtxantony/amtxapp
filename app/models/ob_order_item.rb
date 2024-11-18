class ObOrderItem < ApplicationRecord
	belongs_to :ob_order, primary_key: :order_no, foreign_key: :order_no

	scope :within_date_range, ->(start_date, end_date, client_id) {
	    joins(:ob_order).where(ob_orders: { conf_date: start_date..end_date, client_id: client_id })
	  }


	def self.validate_total_lines(order_no)
	    total_count = where(order_no: order_no).count
	    record = find_by(order_no: order_no)
	    
	    if record && total_count == record.total_line
	      # Do nothing, counts match
	      true
	    else
	      # Counts do not match, handle logic here if needed
	      false
	    end
  	end
end
