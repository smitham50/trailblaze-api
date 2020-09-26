class ApplicationController < ActionController::API
    acts_as_token_authentication_handler_for User
    
    def login!
        session[:user_id] = @user.id
    end

    def logged_in?
        !!session[:user_id]
    end

    def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def authorized_user?
        @user == @current_user
    end

    def logout!
        session.clear
    end
end
