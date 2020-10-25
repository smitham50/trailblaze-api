class User < ApplicationRecord
    include SearchLogic
    has_secure_password
    validates :password, confirmation: true
    has_many :user_trails, dependent: :destroy
    has_many :trails, through: :user_trails, dependent: :destroy

    has_many :user_hikes, dependent: :destroy
    has_many :hikes, through: :user_hikes, class_name: "Trail", dependent: :destroy
end
