class User < ApplicationRecord
  has_secure_password
  rolify
end
