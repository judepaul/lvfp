class Speech < ApplicationRecord
  has_one :user_content_map
    require 'securerandom'
    before_save :set_code_for_email
    self.per_page = 10

    protected
    def set_code_for_email
        self.code = SecureRandom.random_number(1000)
    end
end
