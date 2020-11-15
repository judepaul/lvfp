class Audiance < ApplicationRecord
  include Hashid::Rails
  
  belongs_to :user
  belongs_to :access_code
  # check device exists, to prompt for access code
  scope :check_device_exists, -> (device_id) { where device_id: device_id }

end
