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
    acsm = AccessCodeSpeechMap.where(access_code_id: params[:id]).last unless params[:id].blank?
    @speech = Speech.find_by_hashid(acsm.speech_id) unless acsm.blank?
    @access_code = AccessCode.find_by_hashid(params[:id]) unless params[:id].blank?
  end
  
  def view_article
    if params[:pg] == "article_create"
      @speech = Speech.find_by_hashid(params[:id]) unless params[:id].blank?
      acsm = AccessCodeSpeechMap.where(speech_id: @speech.id).last unless @speech.blank?
      @access_code = AccessCode.where(id: acsm.access_code_id).last unless acsm.blank? 
    else
      acsm = AccessCodeSpeechMap.where(access_code_id: params[:id]).last unless params[:id].blank?
      @speech = Speech.find_by_hashid(acsm.speech_id) unless acsm.blank?
      @access_code = AccessCode.find_by_hashid(params[:id]) unless params[:id].blank? 
    end   
  end

  # GET /speeches/new
  def new
    @speech = Speech.new
    if current_user.role == "super_vc_admin"
      @access_codes = AccessCode.all.order('id DESC')
    else
      @access_codes = AccessCode.where(user_id: current_user.id).order('id DESC')
    end
    unless params[:campaign].blank?
      acsm = AccessCodeSpeechMap.where(access_code_id: params[:campaign])
      @speech_access_code = acsm.last.access_code unless acsm.blank?
    end
  end

  # GET /speeches/1/edit
  def edit
    @speeches = Speech.find_by_hashid(params[:id])
    if current_user.role == "super_vc_admin"
      @access_codes = AccessCode.all.order('id DESC')
    else
      @access_codes = AccessCode.where(user_id: current_user.id).order('id DESC')
    end
    acsm = AccessCodeSpeechMap.where(speech_id: @speeches.id)
    @speech_access_code = acsm.last.access_code unless acsm.blank?
    
  end

  # POST /speeches
  # POST /speeches.json
  def create
    @speech = Speech.new(speech_params)
    p speech_params
    ac_id = params[:acc_code_id] unless params[:acc_code_id].blank?
    acc_code_id = AccessCode.get_id_from_hashid ac_id
    respond_to do |format|
      if @speech.save
        # commented by Jude on 02/19/2020. There will access_code_speech_map association instead
        # UserContentMap.create(user_id: current_user.id, speech_id: @speech.id)
        @speech.update_attributes(email_code: @speech.email_code += @speech.id, user_id: current_user.id, draft: true)
        AccessCodeSpeechMap.create(access_code_id: acc_code_id, speech_id: @speech.id)
        # format.html { redirect_to speeches_url(group_code: acc_code_id), notice: 'Speech was successfully created.' }
        format.html { redirect_to edit_speech_path(@speech) }
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
          format.html { redirect_to edit_speech_path(@speech) }
          format.json { render :show, status: :ok, location: @speech }
        elsif(params[:commit] == "Publish")
          # updated by Jude on 04/18/2020 to change the redirect url to skill details
          # format.html { redirect_to published_details_path(@speech) }
          format.html { redirect_to published_skill_details_path }
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
    pg = params[:pg] unless params[:pg].blank?
    @speech = Speech.find_by_hashid(params[:id]) unless params[:id].blank?
    access_code_id = AccessCodeSpeechMap.where(speech_id: @speech.id).last.access_code_id
    access_code_hash = AccessCode.find(access_code_id).hashid
    @speech.destroy
    # speech_id = params[:id]
    # @speech.update_attribute("is_deleted", true)
    unless pg.blank?
      if pg=="view-articles"
        respond_to do |format|
          format.html { redirect_to view_article_path(access_code_hash), notice: 'Speech was successfully destroyed.' }
          format.json { head :no_content }
        end
      elsif pg=="list-articles"
        if params[:group_code].blank?
          respond_to do |format|
            format.html { redirect_to speeches_path, notice: 'Speech was successfully destroyed.' }
            format.json { head :no_content }
          end
        else
          respond_to do |format|
            format.html { redirect_to speeches_path(group_code: access_code_hash), notice: 'Speech was successfully destroyed.' }
            format.json { head :no_content }
          end
        end
      end
    end
  end

  def published_details
    speech_id = params[:speech_id]
    @speech = Speech.find_by_hashid(speech_id)
  end

  def getArticlesByType
    @code = params[:access_code]
    @tab = params[:tab]
    access_code = AccessCode.where(code: @code).last
    speech_ids = access_code.access_code_speech_map.map{|acsm| acsm.speech}
    if current_user.role == "super_vc_admin"
      if @tab=="All"
        @speeches = Speech.where(id: speech_ids).paginate(page: params[:page])
      elsif @tab=="Draft"
        @speeches = Speech.where(id: speech_ids).where(published: false).order('id DESC').paginate(page: params[:page])
      elsif @tab=="Published"
        @speeches = Speech.where(id: speech_ids).where(published: true).order('id DESC').paginate(page: params[:page])
      else
        @speeches = Speech.where(id: speech_ids).order('id DESC').paginate(page: params[:page])
      end  
      @access_code = AccessCode.where(code: @code).last
    else
      if @tab=="All"
        @speeches = Speech.where(id: speech_ids).where(user_id: current_user.id).order('id DESC').paginate(page: params[:page])
      elsif @tab=="Draft"
        # @speeches = Speech.where(user_id: current_user.id, draft: true).where('published is NULL').order('id DESC').paginate(page: params[:page])
        @speeches = Speech.where(id: speech_ids).where(user_id: current_user.id, published: false).order('id DESC').paginate(page: params[:page])
      elsif @tab=="Published"
        @speeches = Speech.where(id: speech_ids).where(user_id: current_user.id, published: true).order('id DESC').paginate(page: params[:page])
      else
        @speeches = Speech.where(id: speech_ids).where(user_id: current_user.id).order('id DESC').paginate(page: params[:page])
      end
      @access_code = AccessCode.where(code: @code).last
    end
    @group_code = params[:group_code] unless params[:group_code].blank?
    respond_to do |format|
      format.js
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_speech
      @speech = Speech.find_by_hashid(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def speech_params
      params.require(:speech).permit(:code, :email_address, :content, :title, :email_from, :email_sent_date, :intro, :outro, :name, :sub_title_text)
    end
end
