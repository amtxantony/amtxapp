json.extract! bill, :id, :customer_id, :start_date, :end_date, :orders, :invoiced, :invoiced_date, :bill_type, :created_at, :updated_at
json.url bill_url(bill, format: :json)
