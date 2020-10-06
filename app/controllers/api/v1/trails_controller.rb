require 'rest-client'
require 'json'

class Api::V1::TrailsController < ApplicationController
    include RestClient

    # Index checks if user has trails stored in db and responds with them. Otherwise trails
    # are fetched from Hiking Project API and persisted to database and associated with
    # current user.
    def index
        user = current_user
        if user.trails.length > 0
            render json: {
                status: :success,
                trails: user.trails
            }
        else
            trail_json = RestClient.get(params[:url])
            trail_hash = JSON.parse(trail_json)

            add_trails(trail_hash, user)
        
            render json: {
                status: :success,
                trails: trail_hash
            }
        end
    end

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
            user.trails << new_trail
        end
    end
end