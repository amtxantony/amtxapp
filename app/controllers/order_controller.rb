require 'axlsx'
class OrderController < ApplicationController
  def index
    @orders = Order.order('id desc').paginate(page: params[:page], per_page: 100)
  end

  def upload_orders
  end

  def bills_orders
  	
  	respond_to do |format|
      format.xlsx {
        xlsx_package = Axlsx::Package.new
        wb = xlsx_package.workbook

        wb.add_worksheet(name: 'Shipped Orders') do |sheet|
          sheet.add_row ['Order Number', 'Customer Prefix', 'Billed?','Postcode','Handling Fee','Shipping Fee'] # Customize with your column names

          orders.each do |item|
            sheet.add_row [item.order_number, item.customer_id, item.billed, item.postcode, item.handling_fee, item.shipping_fee] # Adjust with your actual column names
            order.update!(
              billed: true
            )
          end
        end

        send_data xlsx_package.to_stream.read, filename: "Shipped_Orders_#{DateTime.now().to_s}.xlsx", type: 'application/xlsx', disposition: 'attachment'
      }
    end


    # workbook = Roo::Excelx.new

    # # Add a worksheet
    # workbook.default_sheet = workbook.add_sheet('Data Table')

    # # Add headers
    # headers = ['Order Number', 'Customer Prefix', 'Billed?','Postcode','Handling Fee','Shipping Fee']
    # headers.each_with_index { |header, col_index| workbook.set_value(1, col_index + 1, header) }

    # # Add data
    # orders = Order.where(order_number: params[:order_numbers].split(','))
    # orders.each_with_index do |item, row_index|
    #   workbook.set_value(row_index + 2, 1, item.order_number)
    #   workbook.set_value(row_index + 2, 2, item.customer_id)
    #   workbook.set_value(row_index + 2, 3, item.billed)
    #   workbook.set_value(row_index + 2, 4, item.postcode)
    #   workbook.set_value(row_index + 2, 5, item.handling_fee)
    #   workbook.set_value(row_index + 2, 6, item.shipping_fee)
    #   # Add more columns if needed
    # end

    # # Save the workbook to a file
    # file_path = Rails.root.join('public', 'data_table.xlsx')
    # workbook.to_excel(file_path)

    # send_file file_path, filename: 'data_table.xlsx', type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', disposition: 'attachment'

  end
end
