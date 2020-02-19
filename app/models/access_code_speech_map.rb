class AccessCodeSpeechMap < ApplicationRecord
  belongs_to :access_code
  belongs_to :speech
end
