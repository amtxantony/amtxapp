class CreateShipments < ActiveRecord::Migration[7.0]
  def change
    create_table :shipments do |t|
      t.string :shipment_number
      
      t.string :order_ref  
      t.string :order_ref_alt
      t.string :code

      t.string :ship_from_name
      t.string :ship_from_company
      t.string :ship_from_postcode  
      t.string :ship_from_suburb  
      t.string :ship_from_city  
      t.string :ship_from_state 
      t.string :ship_from_country
      t.string :ship_from_phone
      t.string :ship_from_email
      t.string :ship_from_building
      t.string :ship_from_street

      t.string :ship_to_name
      t.string :ship_to_company
      t.string :ship_to_postcode  
      t.string :ship_to_suburb  
      t.string :ship_to_city  
      t.string :ship_to_state 
      t.string :ship_to_country
      t.string :ship_to_phone
      t.string :ship_to_email
      t.string :ship_to_building
      t.string :ship_to_street 

      t.float :weight
      t.float :width
      t.float :length
      t.float :height
      
      t.string :carrier
      t.string :carrier_product_code
      t.boolean :atl
      t.boolean :signature_required
      t.boolean :weekend_delivery
      t.boolean :return_label
      t.string :item_qty_shipped 
      t.datetime :label_printed_date
      t.datetime :pick_up_date
      t.datetime :out_for_delivery_date
      t.datetime :delivered_date
      t.string :manifest_number
      t.datetime :manifest_date  
      t.string :tracking_number
      t.string :pod
      t.timestamps
    end
  end
end
