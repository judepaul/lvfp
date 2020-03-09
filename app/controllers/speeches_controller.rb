class SpeechesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_speech, only: [:show, :edit, :update, :destroy]

  # GET /speeches
  # GET /speeches.json
  def index
    @speeches = Speech.where(user_id: current_user.id).order('id DESC').paginate(page: params[:page])
    @access_codes = AccessCode.where(user_id: current_user.id).order('id DESC')
    @group_code = params[:group_code] unless params[:group_code].blank?
  end

  # GET /speeches/1
  # GET /speeches/1.json
  def show
  end

  # GET /speeches/new
  def new
    @speech = Speech.new
    @access_codes = AccessCode.where(user_id: current_user.id).order('id DESC')
  end

  # GET /speeches/1/edit
  def edit
  end

  # POST /speeches
  # POST /speeches.json
  def create
    @speech = Speech.new(speech_params)
    acc_code_id = params[:acc_code_id] unless params[:acc_code_id].blank?
    respond_to do |format|
      if @speech.save
        # commented by Jude on 02/19/2020. There will access_code_speech_map association instead
        # UserContentMap.create(user_id: current_user.id, speech_id: @speech.id)
        @speech.update_attributes(email_code: @speech.email_code += @speech.id, user_id: current_user.id)
        AccessCodeSpeechMap.create(access_code_id: acc_code_id, speech_id: @speech.id)
        format.html { redirect_to speeches_url(group_code: acc_code_id), notice: 'Speech was successfully created.' }
        format.json { render :new, status: :created, location: @speech }
      else
        format.html { render :new }
        format.json { render json: @speech.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /speeches/1
  # PATCH/PUT /speeches/1.json
  def update
    respond_to do |format|
      if @speech.update(speech_params)
        format.html { redirect_to @speech, notice: 'Speech was successfully updated.' }
        format.json { render :show, status: :ok, location: @speech }
      else
        format.html { render :edit }
        format.json { render json: @speech.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /speeches/1
  # DELETE /speeches/1.json
  def destroy
    # Get Group Id to show the accordion after delete
    access_code_id = AccessCodeSpeechMap.where(speech_id: params[:id]).last.access_code_id unless params[:id].blank?
    @speech.destroy
    # speech_id = params[:id]
    # @speech.update_attribute("is_deleted", true)
    respond_to do |format|
      format.html { redirect_to speeches_url(group_code: access_code_id), notice: 'Speech was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_speech
      @speech = Speech.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def speech_params
      params.require(:speech).permit(:code, :email_address, :content)
    end
end
