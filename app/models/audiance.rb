class Audiance < ApplicationRecord
  belongs_to :user

  # check device exists, to prompt for access code
  scope :check_device_exists, -> (device_id) { where device_id: device_id }

end
