class Api::V1::ContactsController < Api::V1::BaseController 
  def create
    if params[:email].blank?
      render json: { alert: "Email can't be blank" }, status: 422
    elsif params[:body].blank?
      render json: { alert: "Body can't be blank" }, status: 422
    else
      ContactMailer.delay.contact_us(params[:email], params[:body])    
      render json: { }, status: :ok
    end
  end
end
