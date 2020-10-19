class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    Rails.logger.info "@@@@@@@@@@@@@@@"
    Rails.logger.info "#{current_user}"
    Rails.logger.info "#{current_user.role}"
    if current_user.role == "super_vc_admin"
      @campaigns_count = AccessCode.count
      @articles_count = Speech.count
      @campaigns = AccessCode.all
      @articles = Speech.all
    else
      # Commented by Jude on 03/04/2020, to show the dashboard for the vc_admins too
      # redirect_to access_codes_path #, notice: "Welcome to Launch Voice Reader Portal. Creating new campaign will generate an access code for your subscribers. Ask them to use this code while invoke the skill from Voice enabled devices."
    end
  end
  
end
