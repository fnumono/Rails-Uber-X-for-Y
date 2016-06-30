class Api::V1::ClientSettingsController < Api::V1::BaseController 
  before_action :authenticate_client!

  def show    
    render json: current_client.client_setting || current_client.create_client_setting
  end

  def update
    @client_setting = current_client.client_setting || client_setting.build_client_setting
    if @client_setting.update(client_setting_params)
      render json: {}
    else
      render json: { alert: @client_setting.errors.full_messages.first }, status: 422
    end
  end

  def client_setting_params
    params.permit(:status_update_email, :status_update_sms, :provider_update_email, :provider_update_sms, 
      :hours, :hours_email, :hours_sms, :funds, :funds_email, :funds_sms)
  end
end
