class Speech < ApplicationRecord
  # commented by Jude on 02/19/2020. There will access_code_speech_map association instead
  # has_one :user_content_map
  has_one :access_code_speech_map
    require 'securerandom'
    before_save :set_code_for_email
    self.per_page = 10

    protected
    def set_code_for_email
        self.email_code = SecureRandom.random_number(1000)
    end
end
