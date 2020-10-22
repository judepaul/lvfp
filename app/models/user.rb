class User < ApplicationRecord

  has_many :audiances
  has_many :listeners
  has_many :access_code
  # belongs_to :lead

  scope :user_by_code, -> (access_code) { where access_code: access_code}
  # Assign role to new user
  after_save :set_default_role

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable

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


# Override Signup without Password
def password_required?
  super if confirmed?
end

def password_match?
  self.errors[:password] << "can't be blank" if password.blank?
  self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
  self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
  password == password_confirmation && !password.blank?
end


protected

def self.find_first_by_auth_conditions(warden_conditions)
  conditions = warden_conditions.dup
  if login = conditions.delete(:username)
    where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
  else
    where(conditions).first
  end
end

# def self.find_for_database_authentication(warden_conditions)
#     conditions = warden_conditions.dup
#     login = conditions.delete(:username)
#         where(conditions).where(["lower(username) = :value", { :value => login.downcase }]).first
#     if login = conditions.delete(:username)
#        # Commented Email login feature and reverted to Username Login - Jude 10/19/2020
#        # where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
#        where(conditions).where(["lower(username) = :value", { :value => login.downcase }]).first
#     else
#        where(conditions.to_h).first
#     end
# end

  # def self.find_for_database_authentication(warden_conditions)
  #   conditions = warden_conditions.dup
  #   login = conditions.delete(:username)
  #   where(conditions).where(["lower(username) = :value", { :value => login.downcase }]).first
  # end


end
