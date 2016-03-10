#Base controller which inherited by every api controller
class Api::V1::NotificationsController < Api::V1::BaseController  
  before_action :authenticate_client!
 
  # def index
  #   render json: current_provider.setting
  # end

  def my_notification
  	limit = params[:limit].blank? ? 8 : params[:limit].to_i
  	after = params[:after].blank? ? current_client.notifications.last.id + 1 : params[:after].to_i
    notifications = current_client.notifications.order(updated_at: :DESC).where('id < ?', after).limit(limit)
    render json: {notifications: notifications}
  end

  
end
