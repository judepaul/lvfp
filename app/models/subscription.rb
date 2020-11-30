class Subscription < ApplicationRecord
  belongs_to :audiance
  belongs_to :access_code
end
