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
  # curl -d "api_secret=dsdfdsfswvf3dsdf&invoice=923204115&payment_status=paid" http://localhost:3000/payment_notifications/splitable
  #
  def splitable
    order = Order.find_by_number(params[:invoice])
    if order.preferred_api_secret == params[:api_secret]
      order.update_attributes!(status: params[:payment_status])
      render :nothing => true
    else
      # TODO do not return 200
      render :nothing => true
    end
  end

end
