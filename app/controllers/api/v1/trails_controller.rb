require 'rest-client'
require 'json'

class Api::V1::TrailsController < ApplicationController
    include RestClient

    # Index checks if user has trails stored in db and responds with them. Otherwise trails
    # are fetched from Hiking Project API and persisted to database and associated with
    # current user.
    def index
        user = current_user
        byebug
        if user.trails
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
end