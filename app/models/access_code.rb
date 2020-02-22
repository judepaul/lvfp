class AccessCode < ApplicationRecord
    belongs_to :user
    scope :check_code, -> (access_code) { where code: access_code}
    has_many :access_code_speech_map, dependent: :destroy
    has_one :audiance, dependent: :destroy
end
