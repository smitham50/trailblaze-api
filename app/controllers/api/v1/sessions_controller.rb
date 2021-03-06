class Api::V1::SessionsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
        @user = User.find_by(username: session_params[:username])
    
        if @user&.authenticate(session_params[:password])
            login!
            render json: {
                status: 200,
                logged_in: true,
                user: @user.as_json(only: [
                    :id,
                    :username
                ])
            }
        else
            render json: { 
                status: 401,
                errors: ['Login failed, verify credentials and try again']
            }
        end
    end

    def is_logged_in?
        if logged_in? && current_user
            render json: {
                logged_in: true,
                user: current_user
            }
        else
            render json: {
                logged_in: false,
                message: 'no such user'
            }
        end
    end

    def destroy
        logout!
        render json: {
            status: 200,
            logged_out: true
        }
    end

    private
    def session_params
        params.require(:user).permit(:username, :password)
    end

end
