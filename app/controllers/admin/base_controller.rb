class Admin::BaseController < ApplicationController
  protected def ensure_admin_can_access
    @current_user = User.find(session[:user_id]) #What if user not present?
    unless @current_user.role == 'admin' #change column to enum and use enum predicate methods
      respond_to do |format| # No need for this block if only html format is required.
        format.html { redirect_to store_index_url,
          notice: 'You don\'t have privilege to access this section' } # Use I18n.
      end
    end
  end
end
