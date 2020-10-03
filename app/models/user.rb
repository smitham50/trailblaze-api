class User < ApplicationRecord
    acts_as_token_authenticatable
    has_secure_password
    validates :password, confirmation: true
end
