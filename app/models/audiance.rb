class Audiance < ApplicationRecord
  include Hashid::Rails
  
  # check device exists, to prompt for access code
  scope :check_device_exists, -> (device_id) { where device_id: device_id }
  scope :check_user_id_exists, -> (user_id) { where voice_user_id: user_id }
  scope :check_user_access, -> (user_id) { where voice_user_id: user_id }
end
