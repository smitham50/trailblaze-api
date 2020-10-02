class Api::V1::UsersController < ApplicationController
    def create
        @user = User.new(user_params)
        if @user.save
            login!
            render json: {
                status: :created,
                logged_in: true,
                user: @user.as_json(only: [:authentication_token])
            }
        else 
            render json: {
                status: 409,
                errors: @user.errors.full_messages
            }
        end
    end

    def update
        @user = User.find_by(params[:authentication_token])
        @user.update(user_params)
        if @user.save
            render json: {
                status: :update_successful,
                user: @user.as_json(only: [:latitude, :longitude])
            }
        else
            render json: {
                status: 409,
                errors: @user
            }
        end
    end

    private
    def user_params
        params.require(:user).permit(
            :username, 
            :password,
            :password_confirmation,
            :email,
            :address,
            :city,
            :state,
            :zip,
            :authentication_token
        )
    end
end