module AccessCodesHelper
  
  def campaign_name campaign_id
    campaign_name = AccessCode.find_by_hashid(campaign_id).title.titlecase unless campaign_id.blank?
  end
  
  def access_code_id ac_hash_id
    access_code_id = AccessCode.find_by_hashid(ac_hash_id)
  end
  
end
