class Admin::BaseController < ApplicationController
  protected def ensure_admin_can_access
    @current_user = User.find(session[:user_id])
    unless @current_user.role == 'admin'
      respond_to do |format|
        format.html { redirect_to store_index_url, 
          notice: 'You don\'t have privilege to access this section' }
      end
    end
  end
end
