class ApplicationController < ActionController::API
    include ActionController::Cookies
    include ActionController::RequestForgeryProtection

    protect_from_forgery with: :exception, if: Proc.new { |c| c.request.format != 'application/json' }
    protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
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
        current_user.trails.destroy_all
        session.clear
    end

    private

    def set_csrf_cookie
        cookies["CSRF-TOKEN"] = form_authenticity_token
    end
end
