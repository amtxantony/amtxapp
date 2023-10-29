class PackMaterialsController < ApplicationController
  before_action :set_pack_material, only: %i[ show edit update destroy ]
  before_action :to_login_if_no_session

  # GET /pack_materials or /pack_materials.json
  def index
    @pack_materials = PackMaterial.all
  end

  # GET /pack_materials/1 or /pack_materials/1.json
  def show
  end

  # GET /pack_materials/new
  def new
    @pack_material = PackMaterial.new
  end

  # GET /pack_materials/1/edit
  def edit
  end

  # POST /pack_materials or /pack_materials.json
  def create
    @pack_material = PackMaterial.new(pack_material_params)

    respond_to do |format|
      if @pack_material.save
        format.html { redirect_to pack_material_url(@pack_material), notice: "Pack material was successfully created." }
        format.json { render :show, status: :created, location: @pack_material }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pack_material.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pack_materials/1 or /pack_materials/1.json
  def update
    respond_to do |format|
      if @pack_material.update(pack_material_params)
        format.html { redirect_to pack_material_url(@pack_material), notice: "Pack material was successfully updated." }
        format.json { render :show, status: :ok, location: @pack_material }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pack_material.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pack_materials/1 or /pack_materials/1.json
  def destroy
    @pack_material.destroy

    respond_to do |format|
      format.html { redirect_to pack_materials_url, notice: "Pack material was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pack_material
      @pack_material = PackMaterial.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pack_material_params
      params.require(:pack_material).permit(:name, :size, :price, :maxcube)
    end
end
