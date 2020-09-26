class Api::V1::UsersController < ApplicationController
    def create
        @user = User.new(user_params)
        if @user.save
            login!
            render json: {
                status: :created,
                user: @user.as_json(only: [:authentication_token])
            }
        else 
            render json: {
                status: 500,
                errors: @user.errors.full_messages
            }
        end
    end

    private
    def user_params
        params.require(:user).permit(
            :username, 
            :password,
            :password_confirmation,
            :email
        )
    end
end