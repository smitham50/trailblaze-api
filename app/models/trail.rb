class Trail < ApplicationRecord
    belongs_to :user, through: => :trails_users
end
