class InstantPaymentNotificationsController < ApplicationController

  protect_from_forgery :except => [:paypal, :splitable]

  include ActiveMerchant::Billing::Integrations

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

  #
  # curl -d "api_secret=dsdfdsfswvf3dsdf&invoice=923204115&payment_status=paid" http://localhost:3000/instant_payment_notifications/splitable
  #
  def splitable

    # this is line to make the file load which has class_eval code for Order
    PaymentMethod::Splitable

    Rails.logger.info "splitable callback received: #{params.to_yaml}"
    error = validate_splitable_webhook

    if error
      Rails.logger.info "webhook with data #{params.to_yaml} was rejected"
      Rails.logger.info "error: #{error}"
      render nothing: true, status: 403
    else
      order = Order.find_by_number(params[:invoice])
      order.payment_status = params[:payment_status]
      order.payment_method = PaymentMethod::Splitable.first
      order.splitable_transaction_number = params[:transaction_id]
      order.save!
      render nothing: true
    end
  end

  private

  def validate_splitable_webhook
    unless order = Order.find_by_number(params[:invoice])
      return "invoice number #{params[:invoice]} does not match}"
    end

    unless order.splitable_api_secret == params[:api_secret]
      return "api_secret does not match"
    end
    return "payment_status is blank" if params[:payment_status].blank?
    return "transaction_id is blank" if params[:transaction_id].blank?

  end

end
