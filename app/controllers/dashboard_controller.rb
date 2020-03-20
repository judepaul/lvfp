class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    if current_user.role == "super_vc_admin"
      @campaigns_count = AccessCode.count
      @articles_count = Speech.count
      @campaigns = AccessCode.all
      @articles = Speech.all
    else
      redirect_to access_codes_path
    end
  end
end
