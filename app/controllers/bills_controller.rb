require 'cgi'
class BillsController < ApplicationController
  #before_action :set_bill, only: %i[ show edit update destroy ], except: [:vieworders, :vasrecords]
  before_action :to_login_if_no_session

  # GET /bills or /bills.json
  def index
    @bills = Bill.all  
  end

  # GET /bills/1 or /bills/1.json
  def show
  end

  def unload_orders
  end

  # GET /bills/new
  def new
    @bill = Bill.new
  end

  # GET /bills/1/edit
  def edit
  end

  def vasrecords
  end

  # POST /bills or /bills.json
  def create
    @bill = Bill.new(bill_params)

    respond_to do |format|
      if @bill.save
        format.html { redirect_to bill_url(@bill), notice: "Bill was successfully created." }
        format.json { render :show, status: :created, location: @bill }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bills/1 or /bills/1.json
  def update
    respond_to do |format|
      if @bill.update(bill_params)
        format.html { redirect_to bill_url(@bill), notice: "Bill was successfully updated." }
        format.json { render :show, status: :ok, location: @bill }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bills/1 or /bills/1.json
  def destroy
    @bill.destroy

    respond_to do |format|
      format.html { redirect_to bills_url, notice: "Bill was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def generate_ecommerce_bills
    redirect_to :controller =>"order", :action => "index"
  end

  private

  def upload(excel_file)
    uploaded_file = excel_file

    if uploaded_file
      data_array = process_excel_file(uploaded_file.tempfile.path)
      # Use data_array as needed
      return data_array
    else
      render json: { error: 'No file uploaded' }
    end
  end


  def process_excel_file(file_path)
    excel = Roo::Excelx.new(file_path)
    sheet = excel.sheet(0)
    data_array = []

    sheet.each_row_streaming do |row|
      row_data = row.map(&:value)
      data_array << row_data
    end

    data_array
  end


    # Use callbacks to share common setup or constraints between actions.
    def set_bill
      @bill = Bill.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bill_params
      params.require(:bill).permit(:customer_id, :start_date, :end_date, :orders, :invoiced, :invoiced_date, :bill_type, :excel_file)
    end
end
