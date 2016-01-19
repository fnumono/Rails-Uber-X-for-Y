class ApplicationController < ActionController::Base
  # include DeviseTokenAuth::Concerns::SetUserByToken
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) << :fname << :lname << :address1 << :address2 \
      << :city << :state	<< :zip << :phone1 << :phone2 << :photo << :proofinsurance << :driverlicense \
      << :addrlat << :addrlng << :zoom_office_id
  end
end
