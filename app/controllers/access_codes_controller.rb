class AccessCodesController < ApplicationController
  before_action :set_access_code, only: [:show, :edit, :update, :destroy]

  # GET /access_codes
  # GET /access_codes.json
  def index
    if current_user.role == "super_vc_admin"
      @access_codes = AccessCode.all.paginate(page: params[:page])
    else
      @access_codes = AccessCode.where(user_id: current_user.id).order('id DESC').paginate(page: params[:page])
    end
    @status = "Active"
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
    # Commented by Jude on 23/02/2020, group access code is not generated on-demand, either it was auto-generated by the time of record creation.
    #if AccessCode.check_code(access_code_params[:code]).blank?
    if AccessCode.campaign_exists(access_code_params[:title]).blank?
      if Listener.group_exists(params[:listener_group_name]).blank?
        @listener = Listener.create(user_id: current_user.id, group_name: params[:listener_group_name])
      else
        @listener = Listener.where(group_name: params[:listener_group_name]).last
        # respond_to do |format|
        #   format.html { redirect_to access_codes_path, notice: 'Group Name already exists. Please enter another one. ' }
        # end
      end
      respond_to do |format|
      if @access_code.save
        @access_code.update_attributes(user_id: current_user.id, listener_id: @listener.id)
        # format.html { redirect_to new_speech_path, notice: 'Group was successfully created. Now you can add new articles into it' }
        format.html { redirect_to new_speech_path("campaign": @access_code.id, pg: "campaign_create") }
        format.json { render :show, status: :created, location: @access_code }
      else
        format.html { render :new }
        format.json { render json: @access_code.errors, status: :unprocessable_entity }
      end
    end
    else
      respond_to do |format|
        format.html { redirect_to access_codes_path, notice: 'Campaign Name already exists. Please enter another one. ' }
      end
    end
  end

  # PATCH/PUT /access_codes/1
  # PATCH/PUT /access_codes/1.json
def update

  #if AccessCode.campaign_exists(access_code_params[:title]).blank?
    @access_code.listener.update_attribute("group_name", params[:listener_group_name]) unless params[:listener_group_name].blank?
    if @access_code.update(access_code_params)
      respond_to do |format|
        format.html { redirect_to access_codes_path }
        format.json { render :show, status: :ok, location: @access_code }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: @access_code.errors, status: :unprocessable_entity }
      end
    end
  # else
  #   respond_to do |format|
  #     format.html { redirect_to edit_access_code_path, notice: 'Campaign Name already exists. Please enter another one. ' }
  #   end
  # end
end
  # DELETE /access_codes/1
  # DELETE /access_codes/1.json
  def destroy
    # commented on 02/22/2020 by Jude for checking dependent records for the access code before deleting
    active_message_arr = Array.new
    AccessCodeSpeechMap.where(access_code: params[:id]).map {|acm| acm.speech.is_deleted.nil? ? active_message_arr << acm.speech.id : ''}
    p "active_message_arr ==> #{active_message_arr}"
    if active_message_arr.blank?
      @access_code.destroy
      respond_to do |format|
        format.html { redirect_to access_codes_url, notice: 'Campaign was deleted successfully.' }
        format.json { head :no_content }
      end
    else
      p "in else"
      respond_to do |format|
        format.html { redirect_to access_codes_url, notice: 'Access code has associated with some active messages. Please deactivate those before deleting access code' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_access_code
      @access_code = AccessCode.find_by_hashid(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def access_code_params
      params.require(:access_code).permit(:code, :title, :listener_group_name)
    end
end
