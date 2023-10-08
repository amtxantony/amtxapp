class OrderItem < ApplicationRecord
	belongs_to :order, :primary_key=>"order_number",:foreign_key=>"order_number",:class_name=>"Order"
end
