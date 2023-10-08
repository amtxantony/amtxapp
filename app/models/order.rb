class Order < ApplicationRecord
	has_many :order_items, :primary_key =>"order_number", :foreign_key => "order_number", :class_name => "OrderItem"
end
