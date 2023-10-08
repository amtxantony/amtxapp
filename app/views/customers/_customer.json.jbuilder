json.extract! customer, :id, :name, :order_no_prefix, :email, :tier, :created_at, :updated_at
json.url customer_url(customer, format: :json)
