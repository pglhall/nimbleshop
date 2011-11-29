class PaymentNotificationsController < ApplicationController

  protect_from_forgery :except => [:create]

  #curl -d "txn_id=3XC103945N720211C&invoice=923204115&payment_status=Completed" http://localhost:3000/payment_notifications/paypal
  def paypal
    PaymentNotification.create!(params: params,
                                payment_provider: 'paypal',
                                order_number: params[:invoice],
                                status: params[:payment_status],
                                transaction_id: params[:txn_id])
    render :nothing => true
  end

  #curl -d "txn_id=3XC103945N720211C&invoice=923204115&payment_status=Completed" http://localhost:3000/payment_notifications/splitable
  def splitable
    PaymentNotification.create!(params: params,
                                payment_provider: 'splitable',
                                order_number: params[:invoice],
                                status: params[:payment_status],
                                transaction_id: params[:txn_id])
    render :nothing => true
  end

end
