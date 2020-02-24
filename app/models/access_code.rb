class AccessCode < ApplicationRecord
    belongs_to :user, optional: true
    scope :check_code, -> (access_code) { where code: access_code}
    scope :group_name_exists, -> (group_name) { where title: group_name}
    has_many :access_code_speech_map, dependent: :destroy
    has_one :audiance, dependent: :destroy

    before_save :generate_access_code

    protected
    def generate_access_code
        self.code = SecureRandom.random_number(10000)
    end
end
