require 'uri'

class Api::V1::UserHikesController < ApplicationController
    def get_my_hikes
        user = User.find_by(id: params[:user_id])
    end

    def add_trail_to_hikes
        trail_name = URI.unescape(params[:trail_name])
        user = User.find_by(id: params[:user_id])
        trail = Trail.find_by(name: trail_name)

        user_hike = UserHike.new(user.id, trail.id)

        if user_hike.save
            render json: {
                status: :success
            }
        else
            render json: {
                status: 409,
                error: user_hike.errors.full_messages
            }
        end
    end
end