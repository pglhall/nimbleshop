require 'active_merchant/billing/integrations/action_view_helper'

module PaymentProcessorHelper
  include ActiveMerchant::Billing::Integrations::ActionViewHelper

  def notify_url
    public_url_mapped_to_localhost('/admin/payment_methods/paypal_extension/paypal/notify')
  end

  def return_url(order)
    public_url_mapped_to_localhost(paid_order_path(id: order.number, payment_method: :paypal))
  end

  def cancel_url(order)
    public_url_mapped_to_localhost(cancel_order_path(id: order.number))
  end

  private

  def public_url_mapped_to_localhost(url)
    #TODO rather than assuming that only in production one wants to return url
    #make it configurable using application.yml
    #
    return url if Rails.env.production?
    path = []

    tunnel = "#{Rails.root}/config/tunnel"

    if File.exists?(tunnel)
      host = File.open(tunnel, "r").gets.sub("\n", "")
      path << "https://#{host}"
    end

    path << url

    path.join('')
  end
end
