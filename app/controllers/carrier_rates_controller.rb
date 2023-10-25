class CarrierRatesController < ApplicationController
  before_action :set_carrier_rate, only: %i[ show edit update destroy ]
  before_action :to_login_if_no_session

  # GET /carrier_rates or /carrier_rates.json
  def index
    @carrier_rates = CarrierRate.all
  end

  # GET /carrier_rates/1 or /carrier_rates/1.json
  def show
  end

  # GET /carrier_rates/new
  def new
    @carrier_rate = CarrierRate.new
    @carrier_products = CARRIER_PRODUCT_CODES
  end

  # GET /carrier_rates/1/edit
  def edit
  end

  # POST /carrier_rates or /carrier_rates.json
  def create
    carrier_rates = upload(params[:excel_file])
    carrier_rates = carrier_rates.drop(1)

    CarrierRate.where(carrier_product_code: params[:carrier_product]).destroy_all

    carrier_rates.each do |carrier_rate|
      n=1
      while n<=10
        CarrierRate.create!(
            :carrier_product_code => params[:carrier_product],
            :zone => carrier_rate[0],
            :weight_band => n-1,
            :rate => carrier_rate[n]
          )  
        n+=1
      end
    end

    respond_to do |format|
      if carrier_rates.size > 1
        format.html { redirect_to :action => "index", notice: "Carrier rate was successfully created." }
        format.json { render :show, status: :created, location: @carrier_rate }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @carrier_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carrier_rates/1 or /carrier_rates/1.json
  def update
    respond_to do |format|
      if @carrier_rate.update(carrier_rate_params)
        format.html { redirect_to carrier_rate_url(@carrier_rate), notice: "Carrier rate was successfully updated." }
        format.json { render :show, status: :ok, location: @carrier_rate }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @carrier_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carrier_rates/1 or /carrier_rates/1.json
  def destroy
    @carrier_rate.destroy

    respond_to do |format|
      format.html { redirect_to carrier_rates_url, notice: "Carrier rate was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_carrier_rate
      @carrier_rate = CarrierRate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def carrier_rate_params
      params.require(:carrier_rate).permit(:carrier_product_code, :zone, :weight_band)
    end

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
end
