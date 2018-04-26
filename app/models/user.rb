class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :links

  before_save :ensure_authentication_token

  # If the user has no access_token, generate one.
  def ensure_authentication_token
    return if self.access_token.present?

    self.access_token = generate_access_token
  end

  def token
    self.access_token
  end

  def token=(str)
    self.access_token = str
  end

  private

  def generate_access_token
    loop do
      token = Devise.friendly_token
      break token unless User.find_by(access_token: token)
    end
  end

end
