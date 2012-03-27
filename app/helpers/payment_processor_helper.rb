require 'active_merchant/billing/integrations/action_view_helper'

module PaymentProcessorHelper
  include ActiveMerchant::Billing::Integrations::ActionViewHelper

  def notify_url
    add_show_of_as_domain(paypal_instant_payment_notifications_path)
  end

  def return_url(order)
    add_show_of_as_domain(paid_order_path(id: order.number, payment_method: :paypal))
  end

  def cancel_url(order)
    add_show_of_as_domain(cancel_order_path(id: order.number))
  end

  private

  def add_show_of_as_domain(url)
    path = []

    unless Rails.env.production?
      path << ["https://orange-hands.showoff.io"]
    end

    path << url

    path.join('')
  end
end
