class InstantPaymentNotificationsController < ApplicationController

  protect_from_forgery except: [:paypal, :splitable]

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

  def paypal
    notify = PaypalPaymentNotification.create(raw_post: request.raw_post)
    notify.acknowledge
    notify.complete
    render :nothing => true
  end
end
