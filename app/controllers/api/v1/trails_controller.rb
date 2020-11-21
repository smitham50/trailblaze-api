require 'rest-client'
require 'json'
require 'uri'

class Api::V1::TrailsController < ApplicationController
    include RestClient

    def get_trail
        trail_name = URI.unescape(params[:slug])
        trail = Trail.find_by(name: trail_name)

        if trail
            render json: {
                status: :trail_found,
                trail: trail
            }
        else
            render json: {
                status: :trail_not_found,
                errors: trail.errors.full_messages
            }
        end
    end

    # Index checks if user has trails stored in db and responds with them. Otherwise trails
    # are fetched from Hiking Project API and persisted to database and associated with
    # current user.
    def get_trails
        user = current_user

        if user.trails.length == 0
            trail_json = RestClient.get(params[:url])
            trail_hash = JSON.parse(trail_json)

            add_trails(trail_hash)
        end

        trails = user
                    .search_results(
                        params[:latitude], 
                        params[:longitude], 
                        params[:mileage],
                        params[:distance]
                    )
                    .random_twenty

        render json: {
            status: :success,
            trails: trails
        }
    end

    # Adds trails to DB or pulls them from it if they already exist and associates them with user
    def add_trails(trail_hash)
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
                new_trail = Trail.find_by(trail_id: trail["id"])
            end

            user = current_user

            if new_trail && !user.trails.exists?(id: new_trail.id)
                UserTrail.create!(user_id: user.id, trail_id: new_trail.id)
            end
        end
    end

    # Reloads user's 10 search trails if they return to search page
    def search_reload
        trail_ids = params[:trail_ids]
        trails = []

        trail_ids.each {|id| trails << Trail.find_by(id: id.to_i)}

        render json: {
            status: :trails_found,
            trails: trails
        }
    end

end