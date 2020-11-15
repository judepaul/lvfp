class AccessCode < ApplicationRecord
    include Hashid::Rails
    
    belongs_to :user, optional: true
    belongs_to :listener, optional: true
    scope :check_code, -> (access_code) { where code: access_code}
    scope :campaign_exists, -> (campaign_name) { where title: campaign_name}
    has_many :access_code_speech_map, dependent: :destroy
    has_many :audiances, dependent: :destroy
    
    before_save :generate_access_code, :if => :new_record?
    protected
    def generate_access_code
        self.code = SecureRandom.random_number(10000)
    end
end
