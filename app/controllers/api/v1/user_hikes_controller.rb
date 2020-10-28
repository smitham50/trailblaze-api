require 'uri'

class Api::V1::UserHikesController < ApplicationController
    def get_my_hikes
        user = current_user
        hikes = user.user_hikes.map {|hike| Trail.find_by(id: hike.trail_id)}

        render json: {
            hikes: hikes
        }
    end

    def add_trail_to_hikes
        trail_name = URI.unescape(params[:trail_name])
        trail = Trail.find_by(name: trail_name)
        user = current_user

        if !user.user_hikes.any? {|hike| trail.id == hike.trail_id}
            user_hike = UserHike.new(user_id: user.id, trail_id: trail.id)
            if user_hike.save
                render json: {
                    status: :success,
                    trail: trail.name
                }
            else
                render json: {
                    status: 409,
                    error: user_hike.errors.full_messages
                }
            end

        else
            render json: {
                status: :failure,
                error: "#{trail.name} already added to hikes"
            }
        end

        
    end
end