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

    def update
        changed_keys = params[:user].select{|key, value| current_user[key] != value}.keys

        if changed_keys.length == 0
            render json: {
                status: "No changes submitted",
                message: "You haven't submitted any changes",
                error: true
            }
        elsif current_user.update user_params
            message = "Successfully updated #{changed_keys.join(' and ')}"
            render json: {
                status: "Account updated",
                message: message
            }
        else
            render json: {
                status: "Update failed",
                error: current_user.errors.full_messages,
                message: "Unable to update #{changed_keys.join(' and ')}"
            }
        end
    end

    def destroy
        username = current_user[:username]

        if current_user.destroy
            render json: {
                status: "Deleted",
                message: "#{username}'s account has been successfully removed!"
            }
        else
            render json: {
                status: "Delete failed",
                errors: current_user.errors.full_messages,
                message: "Unable to delete #{username}'s account"
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