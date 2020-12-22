class Api::V1::SessionsController < ApplicationController
    def get_key
        render json: {
            key: Rails.application.credentials.google_maps_api_key
        }
    end
end