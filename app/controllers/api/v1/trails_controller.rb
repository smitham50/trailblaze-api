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

    def associate_trails
        user = current_user

        if user.trails.length == 0
            trail_json = RestClient.get(params[:url])
            trail_hash = JSON.parse(trail_json)

            user.add_trails(trail_hash)
        end

        render json: {
            status: "Success"
        }
        
    end

    def search_trails
        user = current_user

        trails = user
                    .search_results(
                        params[:latitude], 
                        params[:longitude], 
                        params[:mileage],
                        params[:distance]
                    )
                    # .random_twenty

        render json: {
            status: :success,
            trails: trails
        }
    end

    # Reloads user's 20 search trails if they return to search page
    def search_reload
        trail_ids = params[:trail_ids]
        trails = []

        if trail_ids.length != 0
            trail_ids.each {|id| trails << Trail.find_by(id: id.to_i)}

            render json: {
                status: :trails_found,
                trails: trails
            }
        end
    end

end