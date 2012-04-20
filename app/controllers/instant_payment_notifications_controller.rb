class InstantPaymentNotificationsController < ApplicationController

  protect_from_forgery except: [:paypal, :splitable]

  include ActiveMerchant::Billing::Integrations

  def splitable
    Rails.logger.info "splitable callback received: #{params.to_yaml}"

    handler = Payment::Handler::Splitable.new(invoice: params[:invoice])

    if handler.acknowledge(params)
      render nothing: true
    else
      Rails.logger.info "webhook with data #{params.to_yaml} was rejected. error: #{handler.errors.join(',')}"
      render "error: #{error}", status: 403
    end
  end

  def paypal
    handler = Payment::Handler::Paypal.new(raw_post: request.raw_post)
    handler.authorize
    render :nothing => true
  end
end
