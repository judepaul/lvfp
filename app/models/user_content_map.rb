class UserContentMap < ApplicationRecord
  include Hashid::Rails
  
  belongs_to :user
  belongs_to :speech
end
