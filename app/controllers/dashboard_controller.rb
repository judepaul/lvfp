class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    @campaigns_count = AccessCode.count
    @articles_count = Speech.count

    @campaigns = AccessCode.all
    @articles = Speech.all
  end
end
