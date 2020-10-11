class Api::V1::UsersController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
        @user = User.new(user_params)
        if @user.save
            login!
            render json: {
                status: :created,
                logged_in: true,
                user: @user.as_json(only: [
                    :id,
                    :username
                ])
            }
        else 
            render json: {
                status: 409,
                errors: @user.errors.full_messages
            }
        end
    end

    # def update
    # end

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