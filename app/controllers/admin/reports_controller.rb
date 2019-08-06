class Admin::ReportsController < Admin::BaseController
  before_action :ensure_admin_can_access #this should be in base_controller
  before_action :set_from_to_date

  def index
    @orders = Order.by_date(@from_date, @to_date)
  end

  private

  def get_date_from_params(date)
    DateTime.new(date[:year].to_i, date[:month].to_i, date[:day].to_i)
  end

  def set_from_to_date
    if params[:from_date].present? && params[:to_date].present?
      @from_date = get_date_from_params(params[:from_date])
      @to_date = get_date_from_params(params[:to_date])
    else
      @from_date = 5.days.ago
      @to_date = Time.now
    end
  end
end
