require 'rest-client'
require 'json'

class Api::V1::TrailsController < ApplicationController
    include RestClient

    # Index checks if user has trails stored in db and responds with them. Otherwise trails
    # are fetched from Hiking Project API and persisted to database and associated with
    # current user.
    def get_trails
        user = current_user

        if user.trails.length == 0
            trail_json = RestClient.get(params[:url])
            trail_hash = JSON.parse(trail_json)

            add_trails(trail_hash, user)
        end

        trails = search_results(user)

        render json: {
            status: :success,
            trails: trails
        }
    end

    # Adds trails to DB or pulls them from it if they already exist and associates them with user
    def add_trails(trail_hash, user)
        trail_hash["trails"].each do |trail|
            new_trail = nil
            if !Trail.exists?(trail_id: trail["id"])
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
                new_trail = Trail.where(:trail_id => trail["id"])
            end

            if !user.trails.exists?(new_trail)
                user.trails << new_trail
            end
        end
    end

    # Maybe not the best place for this method, but I do need the lat/long params.
    # Think of better way to handle this.
    def search_results user
        trails = []

        user.trails.each do |trail|
            if trail.calculate_distance(params[:latitude], params[:longitude]).to_i <= params[:distance].to_i
                min_mileage = 0 
                max_mileage = 0
                
                case params[:mileage]
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

                if trails.length < 10
                    if !trails.include?(trail) && trail.length >= min_mileage.to_f && trail.length <= max_mileage.to_f
                        trails << trail
                    end
                else
                    break
                end
            end
        end
        trails
    end

end