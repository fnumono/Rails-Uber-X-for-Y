class Api::V1::ServerSettingsController < Api::V1::BaseController 
  def show    
    render json: ServerSetting.first || ServerSetting.create(price_per_hour: 12)
  end
end
