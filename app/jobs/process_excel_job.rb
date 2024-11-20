class ProcessExcelJob < ApplicationJob
  queue_as :default

  def perform(file_path, client_id)
    spreadsheet = Roo::Spreadsheet.open(file_path)

    if client_id == "ACR"
      header = spreadsheet.row(5) # Assumes the first row contains headers
      (6..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        if !row['Owner'].nil?
          if row['Status'] == "Ready to Deliver" && row['Owner'].to_i > 100

            current_order_no = row['Order']

            existing_record = ObOrder.find_by(order_no: current_order_no)
            if existing_record
              # Compare and update the date if the new date is later
              new_date = parse_date(row['Deliv Date'])
              existing_date = existing_record.conf_date
              if new_date > existing_date
                existing_record.update(conf_date: new_date)
              end
            else
              # Create a new record if it doesn't exist
              ObOrder.create(
                warehouse: "Mel1",
                vendor: row['Owner'],
                order_no: current_order_no,
                so_type: "B2C",
                client_id: 'ACR',
                delivery_date: parse_date(row['Deliv Date']),
                conf_date: parse_date(row['Deliv Date'])
              )
            end

            if ObOrderItem.validate_total_lines(row['Order'])
              ObOrderItem.create(
                order_no: row['Order'].to_s,
                product_type: 'ACR_general',
                sku: row['Product'].to_s,
                unit: 'Unit',
                qty: row['Picked Qty'].to_i,
                weight: 0.0,
                volume: 0.0,
                total_line: row['Total Lines'].to_i,
                created_at: DateTime.now,
                updated_at: DateTime.now
                )
            end
          end
        end
      end

    elsif client_id == "OC"

      header = spreadsheet.row(1) # Assumes the first row contains headers
      content_from_line = 2

      (content_from_line..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]

        current_order_no = row['Order No']

        existing_record = ObOrder.find_by(order_no: current_order_no)
        if existing_record
          # Compare and update the date if the new date is later
          new_date = parse_date(row['shipment_date'])
          existing_date = existing_record.conf_date
          if new_date > existing_date
            existing_record.update(conf_date: new_date)
          end
        else
          # Create a new record if it doesn't exist
          ObOrder.create(
            warehouse: "Mel1",
            vendor: row['Vendor'],
            order_no: current_order_no,
            so_type: row['SO Type'],
            client_id: 'OC',
            delivery_date: parse_date(row['shipment_date']),
            conf_date: parse_date(row['shipment_date'])
          )
        end

        if ObOrderItem.validate_total_lines(current_order_no)
          ObOrderItem.create(
            order_no: current_order_no,
            product_type: row['Product Type'],
            sku: row['SKU'],
            unit: row['Unit'],
            qty: row['Qty'],
            weight: row['Weight'].to_f,
            volume: row['Volume'].to_f,
            total_line: row['SO Line']
            )
        end
      end
    end

  end


  private

  def parse_date(excel_date)
    if excel_date.is_a?(Integer)
      # Handle Excel serial date numbers
      Date.new(1899, 12, 30) + excel_date.to_i
    elsif excel_date.is_a?(String)
      # Handle string dates
      formats = ['%d/%m/%Y', '%d/%m/%y','%m/%d/%Y %H:%M','%m/%d/%Y %H:%M:%S','%Y/%m/%d %H:%M:%S','%Y/%m/%d %H:%M','%y/%m/%d %H:%M:%S','%y/%m/%d %H:%M'] 
      parsed_date = nil

      formats.each do |format|
        begin
          parsed_date = Date.strptime(excel_date.strip, format)
          # Correct two-digit year if necessary
          if parsed_date.year < 100
            parsed_date = parsed_date.change(year: parsed_date.year + 2000)
          end
          return parsed_date
        rescue ArgumentError
          next # Try the next format
        end
      end
    else
      raise "Unsupported date format: #{excel_date}"
    end
  end
end
