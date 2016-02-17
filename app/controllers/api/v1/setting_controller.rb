#Base controller which inherited by every api controller
class Api::V1::SettingController < Api::V1::BaseController  
  before_action :authenticate_provider!
 
  def index
    render json: current_provider.setting
  end

  def update
    if params[:agreement]
      agreement = params[:agreement] 
      pfname = params[:fullname].gsub(/\s+/, "").downcase
      current_provider_fullname = (current_provider.fname + current_provider.lname)
      if current_provider_fullname.blank?
        render json: { error: 'Please complete your profile before sign on agreement.'}, status: 400 and return
      else
        current_provider_fullname = current_provider_fullname.gsub(/\s+/, "").downcase
      end

      current_provider.setting = current_provider.setting || Setting.create!(provider_id: current_provider.id)
      
      if (pfname == current_provider_fullname)
        current_time = Time.now.to_date
        case agreement
        when '1099' 
          current_provider.setting.update(a1099: current_time)
        when 'confidentiality'
          current_provider.setting.update(confidentiality: current_time)
        when 'noncompete' 
          current_provider.setting.update(noncompete: current_time)
        when 'delivery'
          current_provider.setting.update(delivery: current_time)
        end

        render json: {agree: agreement, time: current_time}        
      else
        render json: { error: 'Please type your full name exactly.'}, status: 400
      end
    
    else
      current_provider.setting.update(update_setting_params)
      render json: {message: 'Your notification setting has been updated!'}
    end  
  end

  private
    def update_setting_params
      params.permit(:sms, :email, :available)
    end
end
