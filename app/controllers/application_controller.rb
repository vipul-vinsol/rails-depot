class ApplicationController < ActionController::Base
  before_action :set_i18n_locale_from_params
  before_action :authorize
  before_action :increment_hit_count_for_page
  before_action :store_user_ip
  before_action :check_and_update_logged_in_cookie

  protect_from_forgery with: :exception

  protected

    def authorize
      if request.format == Mime[:html]
        unless User.find_by(id: session[:user_id])
          redirect_to login_url, notice: "Please log in"
        end
      else
        authenticate_or_request_with_http_basic do |username, password|
          user = User.find_by(name: username)
          user && user.authenticate(password)
        end
      end
    end

    def set_i18n_locale_from_params
      if params[:locale]
        if I18n.available_locales.map(&:to_s).include?(params[:locale])
          I18n.locale = params[:locale]
        else
          flash.now[:notice] = 
            "#{params[:locale]} translation not available"
          logger.error flash.now[:notice]
        end
      end
    end

    def increment_hit_count_for_page
      page = request.fullpath
      page_hit = Pagehit.find_by(page: page)
      if page_hit.present?
        page_hit.count = page_hit.count + 1
        page_hit.save
        @page_hit_count = page_hit.count
      else
        Pagehit.create page: page, count: 1
        @page_hit_count = 1
      end
    end

    def store_user_ip
      @user_ip = request.remote_ip
    end

    def check_and_update_logged_in_cookie
      if cookies[:logged_in]
        cookies.encrypted[:logged_in] = { value: "User is logged in", expires: Time.now + 5.minutes }
      elsif request.fullpath =~ /\/login/
      else
        redirect_to login_url, notice: "You have been logged out due to inactivity, Please login again"
      end
    end
end
