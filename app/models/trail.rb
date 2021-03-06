require "geocoder/stores/active_record"

class Trail < ApplicationRecord
    include Geocoder::Store::ActiveRecord
    has_many :user_trails, dependent: :destroy
    has_many :users, through: :user_trails

    has_many :user_hikes, dependent: :destroy
    has_many :users, through: :user_hikes

    def self.geocoder_options
        { latitude: 'latitude', longitude: 'longitude' }
    end

    # Calculates trail's distance from user's location
    def calculate_distance(latitude, longitude)
        self.distance_to([latitude, longitude])
    end
    
end
