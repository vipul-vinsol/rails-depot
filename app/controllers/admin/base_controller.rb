class Admin::BaseController < ApplicationController
  before_action :ensure_admin_can_access 

  private
   
    def ensure_admin_can_access
      @current_user = User.find_by(session[:user_id]) if session[:user_id]
      unless @current_user.role == 'admin'
        redirect_to store_index_url,
            notice: 'You don\'t have privilege to access this section'
        end
      end
    end
end
