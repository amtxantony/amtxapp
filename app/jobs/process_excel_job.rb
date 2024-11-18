class ProcessExcelJob < ApplicationJob
  queue_as :default

  def perform(file_path)
    spreadsheet = Roo::Spreadsheet.open(file_path)

    header = spreadsheet.row(5) # Assumes the first row contains headers
    (6..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      process_order(row)
      # if row['Status'] == "Ready to Deliver" && row['Owner'] != ""
      #   unless ObOrderItem.validate_total_lines(row['Order'])
      #     ObOrderItem.create(
      #       order_no: row['Order'],
      #       product_type: 'ACR_general',
      #       sku: row['Product'],
      #       unit: 'Unit',
      #       qty: row['Picked Qty'],
      #       weight: 0,
      #       volume: 0,
      #       total_line: row['Total Lines']
      #       )
      #   end
      # end
    end
  ensure
    # Delete the temporary file after processing
    File.delete(file_path) if File.exist?(file_path)
  end

  private

  def process_order(row)
    if row['Status'] == "Ready to Deliver" && row['Owner'] != ""
      unless ObOrderItem.validate_total_lines(row['Order'])
        ObOrderItem.create(
          order_no: row['Order'],
          product_type: 'ACR_general',
          sku: row['Product'],
          unit: 'Unit',
          qty: row['Picked Qty'],
          weight: 0,
          volume: 0,
          total_line: row['Total Lines']
          )
        
      end
    end
  end
end
