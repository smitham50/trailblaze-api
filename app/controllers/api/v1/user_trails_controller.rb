class Api::V1::UserTrailsController < ApplicationController
    skip_before_action :verify_authenticity_token
end