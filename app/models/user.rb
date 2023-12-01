require 'jwt'

class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, uniqueness: true

  def generate_jwt
    JWT.encode({ id: id, exp: 1.day.from_now.to_i }, Rails.application.credentials.secret_key_base)
  end

  def admin?
    self.role == 'admin'
  end
end
