require 'rest-client'
require 'json'

class Api::V1::TrailsController < ApplicationController
    include RestClient
    def index
        trail_json = RestClient.get(params[:url])
        trail_hash = JSON.parse(trail_json)
        render json: {
            status: :success,
            trails: trail_hash
        }
    end
end