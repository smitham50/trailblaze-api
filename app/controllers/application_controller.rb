class ApplicationController < ActionController::API
    include ActionController::Cookies
    include ActionController::RequestForgeryProtection

    protect_from_forgery with: :null_session
    before_action :set_csrf_cookie

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

    private

    def set_csrf_cookie
        cookies["CSRF-TOKEN"] = form_authenticity_token
    end
end
