class CustomerRatecardsController < ApplicationController
  before_action :set_customer_ratecard, only: %i[ show edit update destroy ]
  before_action :to_login_if_no_session

  # GET /customer_ratecards or /customer_ratecards.json
  def index
    @customer_ratecards = CustomerRatecard.all
  end

  # GET /customer_ratecards/1 or /customer_ratecards/1.json
  def show
  end

  # GET /customer_ratecards/new
  def new
    @customer_ratecard = CustomerRatecard.new
  end

  # GET /customer_ratecards/1/edit
  def edit
  end

  # POST /customer_ratecards or /customer_ratecards.json
  def create
    @customer_ratecard = CustomerRatecard.new(customer_ratecard_params)

    respond_to do |format|
      if @customer_ratecard.save
        format.html { redirect_to customer_ratecard_url(@customer_ratecard), notice: "Customer ratecard was successfully created." }
        format.json { render :show, status: :created, location: @customer_ratecard }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @customer_ratecard.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customer_ratecards/1 or /customer_ratecards/1.json
  def update
    respond_to do |format|
      if @customer_ratecard.update(customer_ratecard_params)
        format.html { redirect_to customer_ratecard_url(@customer_ratecard), notice: "Customer ratecard was successfully updated." }
        format.json { render :show, status: :ok, location: @customer_ratecard }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @customer_ratecard.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customer_ratecards/1 or /customer_ratecards/1.json
  def destroy
    @customer_ratecard.destroy

    respond_to do |format|
      format.html { redirect_to customer_ratecards_url, notice: "Customer ratecard was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer_ratecard
      @customer_ratecard = CustomerRatecard.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def customer_ratecard_params
      params.require(:customer_ratecard).permit(:customer_id, :order_fee, :handle_out_fee, :band_1_1st, :band_1_add, :band_2_1st, :band_2_add, :band_3_1st, :band_3_add, :band_4_1st, :band_4_add, :band_5_1st, :band_5_add, :band_6_1st, :band_6_add, :band_6_extra_per_kg)
    end
end
