class User < ApplicationRecord

  has_many :audiances
  has_many :listeners
  has_many :access_code
  belongs_to :lead

  scope :user_by_code, -> (access_code) { where access_code: access_code}
  # Assign role to new user
  after_save :set_default_role

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  enum role: [:user, :system_admin, :vc_admin, :super_vc_admin]

validates :email, uniqueness: false
validates :username, uniqueness: true

# Only allow letter, number, underscore and punctuation.
validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true

  def set_default_role
    self.role ||= :vc_admin
  end

  def email_required?
    false
  end
  def email_changed?
    false
  end
  def will_save_change_to_email?
    false
  end
  
  ['system_admin', 'vc_admin', 'super_vc_admin'].each do |user_role|
    define_method "#{user_role}?" do
        role == user_role
    end
end

  protected

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:username)
    where(conditions).where(["lower(username) = :value", { :value => login.downcase }]).first
  end


end
