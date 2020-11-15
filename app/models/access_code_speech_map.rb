class AccessCodeSpeechMap < ApplicationRecord
  include Hashid::Rails
  
  belongs_to :access_code
  belongs_to :speech
end
