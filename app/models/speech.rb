class Speech < ApplicationRecord
  # commented by Jude on 02/19/2020. There will access_code_speech_map association instead
  # has_one :user_content_map
  has_one :access_code_speech_map, dependent: :destroy
    require 'securerandom'
    before_save :set_code_for_email
    self.per_page = 10

    protected
    def set_code_for_email
        # comment on 02/20/2020 by Jude for Auto incrementing
        # self.email_code = SecureRandom.random_number(1000)
    end
end
