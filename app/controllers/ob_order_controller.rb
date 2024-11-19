class ObOrderController < ApplicationController
  require 'roo'
  require 'axlsx_rails'
  before_action :to_login_if_no_session
  def index
    
  end

  def acr_reports
    start_date = params[:start_date] ? params[:start_date] : 1.month.ago.to_date
    end_date = params[:end_date] ? params[:end_date] : Date.today
    page = params[:page] ? params[:page] : 1

    @ob_order_items_origin = ObOrderItem.within_date_range(start_date, end_date, 'ACR').order(order_no: :desc)
    @ob_order_items = @ob_order_items_origin.paginate(page: page, per_page: 30)
    unique_records = @ob_order_items_origin.uniq { |record| record.order_no }

    # Calculate totals
    @total_orders = unique_records.count
    @total_lines = unique_records.sum(&:total_line)

    respond_to do |format|
      format.html # Render the index view
      format.xlsx { send_exported_file(@ob_order_items_origin, "ACR") }
    end
  end

  def oc_reports
    start_date = params[:start_date] ? params[:start_date] : 1.month.ago.to_date
    end_date = params[:end_date] ? params[:end_date] : Date.today
    page = params[:page] ? params[:page] : 1

    @ob_order_items_origin = ObOrderItem.within_date_range(start_date, end_date, 'OC').order(order_no: :desc)
    @ob_order_items = @ob_order_items_origin.paginate(page: page, per_page: 30)
    unique_records = @ob_order_items_origin.uniq { |record| record.order_no }

    # Calculate totals
    @total_orders = unique_records.count

    #OC_weight_range
    @weight_range = [0..0.25,0.26..0.5,0.51..0.75,0.76..1,1..2,2..3,3..5,5..10,10.01..999]
    @total_qty_first_by_weight = []
    @total_qty_other_by_weight = []
    @total_base_weight_fitem = 0.0
    @total_consequence_weight_fitem = 0.0
    @total_base_weight_oitem = 0.0
    @total_consequence_weight_oitem = 0.0

    i=0
    @weight_range.each do |wr|
      @total_qty_first_by_weight[i] = unique_records.select{ |r| wr.cover?(r.weight) && r.total_line.to_i == 1 }.sum(&:qty)
      @total_qty_other_by_weight[i] = unique_records.select{ |r| wr.cover?(r.weight) && r.total_line.to_i > 1 }.sum(&:qty)

      if wr.begin > 10
        @total_base_weight_fitem = @total_qty_first_by_weight[i] * 10
        @total_consequence_weight_fitem = unique_records.select{ |r| wr.cover?(r.weight) && r.total_line.to_i == 1 }.sum(&:weight) - @total_base_weight_fitem
        @total_base_weight_oitem = @total_qty_other_by_weight[i] * 10
        @total_consequence_weight_oitem = unique_records.select{ |r| wr.cover?(r.weight) && r.total_line.to_i > 1 }.sum(&:weight) - @total_base_weight_oitem
      end
      i+=1
    end

    respond_to do |format|
      format.html # Render the index view
      format.xlsx { send_exported_file(@ob_order_items_origin, "OC") }
    end

  end

  def acr_upload
    file = params[:file]
    if file
      filename = File.basename(file.original_filename)
      if filename.include?('ORD')
          acr_process_file_ord(file)
      elsif filename.include?('DOL')
          acr_process_file_dol(file)
      else
          redirect_to '/ob_order/acr_reports', alert: 'Unsupported file type.'
          return
      end
      redirect_to '/ob_order/acr_reports', notice: 'File processed successfully, or running on the background.'
    else
      redirect_to '/ob_order/acr_reports', alert: 'Please upload a file.'
    end
  end

  def oc_upload
    file = params[:file]
    if file
      oc_process_file(file)
      redirect_to '/ob_order/oc_reports', notice: 'File processed successfully.'
    else
      redirect_to '/ob_order/oc_reports', alert: 'Please upload a file.'
    end
  end

  private

  def send_exported_file(ob_order_items,client_id)
    file = generate_excel(ob_order_items,client_id)
    #send_data file.to_stream.read,
    send_file file,
              filename: "ob_order_items_#{Time.now.strftime('%Y%m%d%H%M%S')}.xlsx",
              type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  # ensure
  #   File.delete(file) if File.exist?(file) # Clean up the temporary file
  end

  def generate_excel(ob_order_items,client_id)
    filepath = Rails.root.join("tmp", "ob_order_items_#{SecureRandom.uuid}.xlsx")
    Axlsx::Package.new do |package|
      package.workbook.add_worksheet(name: "ObOrderItems") do |sheet|
        # Header Row
        sheet.add_row ["Order No", "product_type", "sku", "unit","qty","weight","volume","SO line","Client ID","conf date"]
        # Data Rows
        ob_order_items.each do |item|
          sheet.add_row [
            item.order_no,
            item.product_type,
            item.sku,
            item.unit,
            item.qty,
            item.weight,
            item.volume,
            item.total_line,
            client_id,
            item.ob_order.conf_date.strftime("%d/%m/%Y")
          ]
        end
      end
      package.serialize(filepath.to_s)
    end
    filepath
  end

  def acr_process_file_dol(file)
    # Save the uploaded file to a temporary location
    temp_file_path = Rails.root.join('tmp', file.original_filename)
    File.open(temp_file_path, 'wb') { |f| f.write(file.read) }

    # Enqueue the background job
    #ProcessExcelJob.perform_later(temp_file_path.to_s)
    spreadsheet = Roo::Spreadsheet.open(temp_file_path.to_s)

    header = spreadsheet.row(5) # Assumes the first row contains headers
    (6..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      if !row['Owner'].nil?
        if row['Status'] == "Ready to Deliver" && row['Owner'].to_i > 100

          if ObOrderItem.validate_total_lines(row['Order'])
            ObOrderItem.create!(
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
  end

  def acr_process_file_ord(file)
    spreadsheet = Roo::Spreadsheet.open(file.path)

    header = spreadsheet.row(3) # Assumes the first row contains headers

    (4..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      # if row['Status'] == "Ready to Deliver"
      #   puts "#{row['Conf. Date']}==========#{parse_date(row['Conf. Date'])}===="
      # end

        if row['Status'] == "Ready to Deliver"
          existing_record = ObOrder.find_by(order_no: row['Order No.'])
          if existing_record
            # Compare and update the date if the new date is later
            new_date = parse_date(row['Conf. Date'])
            existing_date = existing_record.conf_date
            if new_date > existing_date
              existing_record.update(conf_date: new_date)
            end
          else
            # Create a new record if it doesn't exist
            ObOrder.create(
              warehouse: 'MEL1',
              vendor: row['Owner'],
              order_no: row['Order No.'],
              so_type: 'B2C',
              client_id: 'ACR',
              delivery_date: parse_date(row['DelDate']),
              conf_date: parse_date(row['Conf. Date'])
            )
          end
        end   
    end
  end

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

  def oc_process_file(file)
    spreadsheet = Roo::Spreadsheet.open(file.path)
    header = spreadsheet.row(1) # Assumes the first row contains headers
    content_from_line = 2

    order_no_counts = Hash.new(0)

    # Loop through the rows
    (content_from_line..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      order_no = row['Order No'] 

      # Increment the count for this order_no
      order_no_counts[order_no] += 1
    end


    (content_from_line..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]

      current_order_no = row['Order No']

      puts row

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

      unless ObOrderItem.validate_total_lines(current_order_no)
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
