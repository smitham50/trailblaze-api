class Trail < ApplicationRecord
    has_many :user_trails
    has_many :users, through: :user_trails

    def add_trails(trail_hash, user)
        trail_hash.each do |trail|
            new_trail
            if !Trail.exists?(trail_id: trail.id)
                new_trail = Trail.create!(
                    trail_id: trail.id,
                    name: trail.name,
                    type: trail.type,
                    summary: trail.summary,
                    difficulty: trail.difficulty,
                    stars: trail.stars,
                    starVotes: trail.starVotes,
                    location: trail.location,
                    url: trail.url,
                    imgSqSmall: trail.imgSqSmall,
                    imgMedium: trail.imgMedium,
                    length: trail.length,
                    ascent: trail.ascent,
                    descent: trail.descent,
                    high: trail.high,
                    low: trail.low,
                    longitude: trail.longitude,
                    latitude: trail.latitude,
                    conditionStatus: trail.conditionStatus,
                    conditionDetails: trail.conditionDetails
                )
            else
                new_trail = Trail.where(:trail_id => trail.id)
            end
            user.trails << new_trail
        end
    end
end
