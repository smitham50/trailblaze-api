# lib/search_logic.rb

module SearchLogic
    extend ActiveSupport::Concern

    def search_results(latitude, longitude, mileage, distance)
        user = self
        trails = []

        user.trails.each do |trail|
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

                if !trails.include?(trail) && trail.length >= min_mileage.to_f && trail.length <= max_mileage.to_f
                    trails << trail
                end

            end
        end
        trails
    end

end