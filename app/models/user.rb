class User < ApplicationRecord
  has_secure_password
  rolify

  validates :name, :email, presence: true
end
