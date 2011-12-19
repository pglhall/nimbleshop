class PaymentNotificationsController < ApplicationController

  protect_from_forgery :except => [:paypal, :splitable]

  #
  #curl -d "txn_id=3XC103945N720211C&invoice=923204115&payment_status=Completed" http://localhost:3000/payment_notifications/paypal
  #
  def paypal
    Rails.logger.info params.inspect
    order = Order.find_by_number(params[:invoice])
    order.update_attribute('status', 'paid')
    #PaymentNotification.create!(params: params,
                                #payment_provider: 'paypal',
                                #order_number: params[:invoice],
                                #status: params[:payment_status],
                                #transaction_id: params[:txn_id])
    render :nothing => true
  end

  #
  # curl -d "api_secret=xxxx&invoice=923204115&payment_status=paid" http://localhost:3000/payment_notifications/splitable
  #
  def splitable
    Rails.logger.info params.inspect
    render :nothing => true
  end

end
