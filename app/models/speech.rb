class Speech < ApplicationRecord
    require 'securerandom'
    before_save :set_code_for_email

    def set_code_for_email
        self.code = SecureRandom.random_number(1000)
      end
    
end
