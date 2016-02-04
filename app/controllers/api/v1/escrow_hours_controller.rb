class Api::V1::EscrowHoursController < Api::V1::BaseController 
	before_action :authenticate_client!

	api :GET, 'client/escrowhours', 'Get client\'s escrow and hours status'
	error :code => 401, :desc => "Unauthorized"
	description "Get client\'s escrow status and hours status"
	example ' "eh": {
    "id": 5,
    "hoursavail": 10.5,
    "hoursused": 2.5,
    "escrowavail": 210.64,
    "escrowused": 300.82,
    "client_id": 2,
    "created_at": "2016-01-10T10:46:04.314Z",
    "updated_at": "2016-01-10T10:46:58.417Z"
    } '	
	def show
		render json: {eh: current_client.escrow_hour} 
	end

    def charge
      # Amount in cents
      @amount = 50000
      mail = params[:stripeEmail] || current_client.email
      description = mail + ' charged $' + (@amount/100.0).to_s + '.'

      customer = Stripe::Customer.create(
        :email => mail,
        :source  => params[:stripeToken]
      )

      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => @amount,
        :description => description,
        :currency    => 'usd'
      )

      render json: { charge: charge }

    rescue Stripe::CardError => e
        render json: {error: e.message}, status: 422
      
    end
end