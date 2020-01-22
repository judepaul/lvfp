class Speech < ApplicationRecord
    require 'securerandom'
    before_save :set_code_for_email
    self.per_page = 10
    def set_code_for_email
        self.code = SecureRandom.random_number(1000)
      end
    
end
