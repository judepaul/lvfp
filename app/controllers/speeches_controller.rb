class SpeechesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_speech, only: [:show, :edit, :update, :destroy]

  # GET /speeches
  # GET /speeches.json
  def index
    if current_user.role == "super_vc_admin"
      @speeches = Speech.all.paginate(page: params[:page])
      @access_codes = AccessCode.all.order('id DESC')
    else
      @speeches = Speech.where(user_id: current_user.id).order('id DESC').paginate(page: params[:page])
      @access_codes = AccessCode.where(user_id: current_user.id).order('id DESC')
    end
    @group_code = params[:group_code] unless params[:group_code].blank?
  end

  # GET /speeches/1
  # GET /speeches/1.json
  def show
  end

  # GET /speeches/new
  def new
    @speech = Speech.new
    if current_user.role == "super_vc_admin"
      @access_codes = AccessCode.all.order('id DESC')
    else
      @access_codes = AccessCode.where(user_id: current_user.id).order('id DESC')
    end
  end

  # GET /speeches/1/edit
  def edit
    @speeches = Speech.find(params[:id])
    if current_user.role == "super_vc_admin"
      @access_codes = AccessCode.all.order('id DESC')
    else
      @access_codes = AccessCode.where(user_id: current_user.id).order('id DESC')
    end
    @speech_access_code = AccessCodeSpeechMap.where(speech_id: params[:id]).last.access_code
  end

  # POST /speeches
  # POST /speeches.json
  def create
    @speech = Speech.new(speech_params)
    p speech_params
    acc_code_id = params[:acc_code_id] unless params[:acc_code_id].blank?
    respond_to do |format|
      if @speech.save
        # commented by Jude on 02/19/2020. There will access_code_speech_map association instead
        # UserContentMap.create(user_id: current_user.id, speech_id: @speech.id)
        @speech.update_attributes(email_code: @speech.email_code += @speech.id, user_id: current_user.id, draft: true)
        AccessCodeSpeechMap.create(access_code_id: acc_code_id, speech_id: @speech.id)
        # format.html { redirect_to speeches_url(group_code: acc_code_id), notice: 'Speech was successfully created.' }
        format.html { redirect_to edit_speech_path(@speech), notice: "One more step needs to be done to make this available to your users. Click the Publish button to get published.".html_safe }
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
        if params[:commit] == "Save"
          @speech.draft = true
        elsif(params[:commit] == "Publish")
          @speech.published = true
        end
      if @speech.update(speech_params)
        if params[:commit] == "Save"
          format.html { redirect_to edit_speech_path(@speech), notice: "One more step needs to be done to make this available to your users. Click the Publish button to get published.".html_safe }
          format.json { render :show, status: :ok, location: @speech }
        elsif(params[:commit] == "Publish")
          format.html { redirect_to published_details_path(@speech) }
          format.json { render :show, status: :ok, location: @speech }
        end
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

  def published_details
    speech_id = params[:speech_id]
    @speech = Speech.find(speech_id)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_speech
      @speech = Speech.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def speech_params
      params.require(:speech).permit(:code, :email_address, :content, :title, :email_from, :email_sent_date, :intro, :outro)
    end
end
