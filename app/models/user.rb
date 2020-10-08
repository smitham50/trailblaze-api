class User < ApplicationRecord
    include SearchLogic
    has_secure_password
    validates :password, confirmation: true
    has_many :user_trails
    has_many :trails, through: :user_trails
end
