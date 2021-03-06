class Listener < ApplicationRecord
  include Hashid::Rails
  
  belongs_to :user
  has_many :access_codes
  scope :group_exists, -> (group_name) { where group_name: group_name}
end
