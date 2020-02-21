class AccessCode < ApplicationRecord
    belongs_to :user
    scope :check_code, -> (access_code) { where code: access_code}
end
