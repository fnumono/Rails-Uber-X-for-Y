#Base controller which inherited by every api controller
class Api::V1::NotificationsController < Api::V1::BaseController  
  before_action :authenticate_client!
 
  # def index
  #   render json: current_provider.setting
  # end

  def my_notification
    notifications = current_client.notifications
    render json: {notification: notifications}
  end

  
end
