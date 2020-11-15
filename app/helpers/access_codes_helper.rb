module AccessCodesHelper
  
  def campaign_name campaign_id
    campaign_name = AccessCode.find_by_hashid(campaign_id).title.titlecase unless campaign_id.blank?
  end
  
end
