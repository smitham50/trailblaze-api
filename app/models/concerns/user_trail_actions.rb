# lib/search_logic.rb

module UserTrailActions
    extend ActiveSupport::Concern

    def search_results(latitude, longitude, mileage, distance)
        user = self
        trails = []

        user.trails.map do |trail|
            if trail.calculate_distance(latitude, longitude).to_i <= distance.to_i
                min_mileage = 0 
                max_mileage = 0
                
                case mileage
                when 'Less than 3'
                    min_mileage = 0
                    max_mileage = 3
                when '3 to 5'
                    min_mileage = 3
                    max_mileage = 5
                when '6 to 9'
                    min_mileage = 6
                    max_mileage = 9
                end

                if !trails.include?(trail) && trail.length >= min_mileage.to_f && trail.length <= max_mileage.to_f && trail.imgMedium != ""
                    trails << trail
                end

            end
        end
        trails
    end

    # Adds trails to DB or pulls them from it if they already exist and associates them with user
    def add_trails(trail_hash)
        trail_hash["trails"].each do |trail|
            new_trail = nil
            user = self
            
            if !Trail.exists?(trail_id: trail["id"]) && trail["imgMedium"] != ""
                new_trail = Trail.create!(
                    trail_id: trail["id"],
                    name: trail["name"],
                    summary: trail["summary"],
                    difficulty: trail["difficulty"],
                    stars: trail["stars"],
                    starVotes: trail["starVotes"],
                    location: trail["location"],
                    url: trail["url"],
                    imgSqSmall: trail["imgSqSmall"],
                    imgMedium: trail["imgMedium"],
                    length: trail["length"],
                    ascent: trail["ascent"],
                    descent: trail["descent"],
                    high: trail["high"],
                    low: trail["low"],
                    longitude: trail["longitude"],
                    latitude: trail["latitude"],
                    conditionStatus: trail["conditionStatus"],
                    conditionDetails: trail["conditionDetails"]
                )
            else
                new_trail = Trail.find_by(trail_id: trail["id"])
            end

            if new_trail && !user.trails.exists?(trail_id: trail["id"])
                UserTrail.create!(user_id: user.id, trail_id: new_trail.id)
            end
        end
    end

end