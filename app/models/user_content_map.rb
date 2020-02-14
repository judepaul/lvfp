class UserContentMap < ApplicationRecord
  belongs_to :user
  belongs_to :speech
end
