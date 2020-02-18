class User < ApplicationRecord

  has_many :audiances
  has_many :user_content_map
  has_many :access_code


  scope :user_by_code, -> (access_code) { where access_code: access_code}
  # Assign role to new user
  after_save :set_default_role, :if => :new_record?

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  enum role: [:user, :system_admin, :vc_admin]

  def set_default_role
    self.role ||= :vc_admin
  end


end
