class ObOrder < ApplicationRecord
	has_many :ob_order_items, primary_key: :order_no, foreign_key: :order_no
end
