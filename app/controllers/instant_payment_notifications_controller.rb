class InstantPaymentNotificationsController < ApplicationController

  protect_from_forgery :except => [:paypal, :splitable]

  include ActiveMerchant::Billing::Integrations

  def splitable
    Rails.logger.info "splitable callback received: #{params.to_yaml}"
    error = PaymentMethod::Splitable.validate_splitable_webhook

    if error
      Rails.logger.info "webhook with data #{params.to_yaml} was rejected. error: #{error}"
      render "error: #{error}", status: 403
    else
      render nothing: true
    end
  end

  #
  #curl -d "txn_id=3XC103945N720211C&invoice=923204115&payment_status=Completed" http://localhost:3000/instant_payment_notifications/paypal
  #
  def paypal
    Rail.logger.info "paypal callback received: #{params.to_yaml}"
    transaction = PaypalTransaction.find_by_invoice!(params[:invoice])
    render :nothing => true and return if transaction.status == 'paid'

    order = Order.find_by_number!(params[:invoice])
    notify = Paypal::Notification.new(request.raw_post)

    if notify.acknowledge
      begin
        if notify.complete? && order.grand_total == notify.amount
          order.status = 'paid'
          transaction.update_attributes!(params: params, status: params[:payment_status], txn_id: params[:txn_id])
        else
          # TODO notify airbrake
          Rails.logger.info("Failed to verify Paypal's notification. Investigation needed");
        end
      rescue => e
        order.status = 'failed_ipn'
        raise e
      ensure
        order.save
      end
    end
    render :nothing => true
  end


end
