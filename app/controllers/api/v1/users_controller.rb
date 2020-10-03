class Api::V1::UsersController < ApplicationController
    def create
        @user = User.new(user_params)
        if @user.save
            login!
            render json: {
                status: :created,
                logged_in: true,
                user: @user.as_json(only: [
                    :authentication_token,
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
            :email,
            :authentication_token
        )
    end
end