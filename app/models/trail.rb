class Trail < ApplicationRecord
    belongs_to :user, through: => :users_trails
end
