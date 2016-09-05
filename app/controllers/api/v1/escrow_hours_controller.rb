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

  def fee
    fee = Fee.first
    render json: {fee: fee}
  end

  def coupon_check
    code = params[:couponCode]

    if (code.blank?) || (code == 0)
      render json: {error: 'Please input coupon code.'}, status: 400 and return
    end

    @coupon = Coupon.get(code)

    if @coupon.nil?
      render json: {error: 'Coupon code is not valid or expired.'}, status: 400 and return
    end

    render json: {percent: @coupon.discount_percent}
  end

  def charge
    # Amount in cents
    params[:purchaseEscrow] = 0 if params[:purchaseEscrow].blank?
    params[:purchaseHour] = 0 if params[:purchaseHour].blank?
    mail = params[:stripeEmail] || current_client.email
    charge_metadata = {purchaseHour: params[:purchaseHour], purchaseEscrow: params[:purchaseEscrow], \
                        email: mail}

    code = params[:couponCode]

    if (!code.blank?) && (code != 0)
      @coupon = Coupon.get(code)

      if @coupon.nil?
        render json: {error: 'Coupon code is not valid or expired.'}, status: 400 and return
      end

      charge_metadata[:coupon_code] = @coupon.code
      charge_metadata[:coupon_discount] = @coupon.discount_percent_human
    end

    @amount = calc_amount(params[:purchaseHour], params[:purchaseEscrow], @coupon)
    @final_amount = ((@amount + params[:otherPayment].to_f) * 100).to_i  #cent unit
    render json: {error: 'Invalid purchaseHour or purchaseEscrow'}, status: 400 and return  if @final_amount <= 0


    description = mail + ' charged $' + (@final_amount/100.0).to_s

    # customer = Stripe::Customer.create(
    #   :email => mail,
    #   :source  => params[:stripeToken]
    # )

    stripe_charge = Stripe::Charge.create(
      # :customer    => customer.id,
      # :email => mail,
      :source  => params[:stripeToken],
      :amount      => @final_amount,
      :description => description,
      :currency    => 'usd',
      :metadata    => charge_metadata
    )

    eh = current_client.escrow_hour
    current_client.escrow_hour.hoursavail += params[:purchaseHour]
    current_client.escrow_hour.escrowavail += params[:purchaseEscrow]
    if !current_client.escrow_hour.save
      render json: { error: 'Failed on Saving client information. Please contact with Support team'}, status: 422 and return
    end

    @charge = Charge.create!(amount: @final_amount, coupon: @coupon, stripe_id: stripe_charge.id)

    if (params[:purchaseEscrow] != 0) && (params[:purchaseHour] != 0)
      current_client.notifications.create(notify_type: Settings.notify_finance, name: "Purchase hours and fund escrow", \
        text: "Purchase hours: " + params[:purchaseHour].to_s + ", Fund escorw: $" + params[:purchaseEscrow].to_s)
    elsif (params[:purchaseEscrow] == 0) && (params[:purchaseHour] != 0)
      current_client.notifications.create(notify_type: Settings.notify_finance, name: "Purchase hours", \
        text: "Purchase hours: " + params[:purchaseHour].to_s)
    elsif (params[:purchaseEscrow] != 0) && (params[:purchaseHour] == 0)
      current_client.notifications.create(notify_type: Settings.notify_finance, name: "Fund escrow", \
        text: "Fund escrow: $" + params[:purchaseEscrow].to_s)
    end

    unless (params[:otherPayment] == 0)
      current_client.notifications.create(notify_type: Settings.notify_finance, name: "Other payment", \
        text: "Payment amount: $" + params[:otherPayment].to_s)
    end

    current_client.payments.create(purchase_hour: params[:purchaseHour], purchase_escrow: params[:purchaseEscrow])


    render json: { charge: @charge, purchaseHour: params[:purchaseHour], purchaseEscrow: params[:purchaseEscrow] }

  rescue Stripe::CardError => e
    render json: {error: e.message}, status: 422 and return
  rescue => e
    render json: {error: 'Invalid request error.'}, status: 400 and return
  end

  private

    def calc_amount(hour, escrow, coupon)
      amount = 0
      fee = Fee.first
      hour_amount = calc_hour_to_amount(hour.to_f)
      hour_amount = coupon.apply_discount(hour_amount.to_i) unless coupon.nil?
      if (hour < 0) || (escrow < 0) || (hour_amount < 0)
        amount = -1
      else
        amount = hour_amount + (escrow.to_f*(1 + fee.percent*0.01) + fee.cent*0.01);  # $unit
      end
      amount
    end

    def calc_hour_to_amount(hour)
      amount = 0
      hour = hour.to_f
      if hour >= 40
        amount = hour * 25
      elsif hour >=30
        amount = hour * 26
      elsif hour >=20
        amount = hour * 26.75
      elsif hour >=10
        amount = hour * 27.5
      elsif hour >=5
        amount = hour * 29
      elsif hour >=1
        amount = hour * 32
      elsif hour >=0
        amount = hour * 32
      else
        amount = -1
      end
      # amount = escrow + hour * 35
      amount
    end

end