class AccessCodesController < ApplicationController
  before_action :set_access_code, only: [:show, :edit, :update, :destroy]

  # GET /access_codes
  # GET /access_codes.json
  def index
    # @access_codes = AccessCode.all
    @access_codes = AccessCode.order('id DESC').paginate(page: params[:page])
  end

  # GET /access_codes/1
  # GET /access_codes/1.json
  def show
  end

  # GET /access_codes/new
  def new
    @access_code = AccessCode.new
  end

  # GET /access_codes/1/edit
  def edit
  end

  # POST /access_codes
  # POST /access_codes.json
  def create
    @access_code = AccessCode.new(access_code_params)
    if AccessCode.check_code(access_code_params[:code]).blank?
      @access_code.user_id = current_user.id
      respond_to do |format|
      if @access_code.save
        format.html { redirect_to access_codes_path, notice: 'Access code was successfully created.' }
        format.json { render :show, status: :created, location: @access_code }
      else
        format.html { render :new }
        format.json { render json: @access_code.errors, status: :unprocessable_entity }
      end
    end
    else
      respond_to do |format|
        format.html { redirect_to access_codes_path, notice: 'Access code already exists. Please enter another one. ' }
      end
    end
  end

  # PATCH/PUT /access_codes/1
  # PATCH/PUT /access_codes/1.json
  def update
    respond_to do |format|
      if @access_code.update(access_code_params)
        format.html { redirect_to @access_code, notice: 'Access code was successfully updated.' }
        format.json { render :show, status: :ok, location: @access_code }
      else
        format.html { render :edit }
        format.json { render json: @access_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /access_codes/1
  # DELETE /access_codes/1.json
  def destroy
    @access_code.destroy
    respond_to do |format|
      format.html { redirect_to access_codes_url, notice: 'Access code was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_access_code
      @access_code = AccessCode.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def access_code_params
      params.require(:access_code).permit(:code, :title)
    end
end
