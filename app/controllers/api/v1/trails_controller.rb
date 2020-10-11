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

        trails = user
                    .search_results(
                        params[:latitude], 
                        params[:longitude], 
                        params[:mileage],
                        params[:distance]
                    )
                    .random_ten

        render json: {
            status: :success,
            trails: trails
        }
    end

    # Adds trails to DB or pulls them from it if they already exist and associates them with user
    def add_trails(trail_hash, user)
        trail_hash["trails"].each do |trail|
            new_trail = nil
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
                new_trail = Trail.where(:trail_id => trail["id"])
            end

            if !user.trails.exists?(new_trail)
                user.trails << new_trail
            end
        end
    end

end