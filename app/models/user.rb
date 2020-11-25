class User < ApplicationRecord
    include UserTrailActions
    has_secure_password
    validates :password, confirmation: true
    validates :username, uniqueness: true
    validates :email, uniqueness: true
    
    has_many :user_trails, dependent: :destroy
    has_many :trails, through: :user_trails

    has_many :user_hikes, dependent: :destroy
    has_many :hikes, through: :user_hikes, class_name: "Trail"
end
