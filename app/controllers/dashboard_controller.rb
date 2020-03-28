class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    if current_user.role == "super_vc_admin"
      @campaigns_count = AccessCode.count
      @articles_count = Speech.count
      @campaigns = AccessCode.all
      @articles = Speech.all
    else
      redirect_to access_codes_path #, notice: "Welcome to Launch Voice First Portal. Creating new campaign will generate an access code for your subscribers. Ask them to use this code while invoke the skill from Voice enabled devices."
    end
  end
end
