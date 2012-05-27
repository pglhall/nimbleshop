require 'active_merchant/billing/integrations/action_view_helper'

module PaymentMethodHelper
  include ActiveMerchant::Billing::Integrations::ActionViewHelper

  def payment_info_for_buyer(order)
    name = order.payment_method.demodulized_underscore
    self.send("nimbleshop_#{name}_payment_info_for_buyer", order)
  end

  def nimbleshop_crud_form(payment_method)
    self.send("nimbleshop_#{payment_method.demodulized_underscore}_crud_form")
  end

  # returns public url for a given localhost url
  def localhost2public_url(url, protocol)
    #TODO rather than assuming that only in production one wants to return url
    #make it configurable using application.yml
    return url if Rails.env.production?

    tunnel = "#{Rails.root}/config/tunnel"
    raise "File  #{Rails.root.join('config', 'tunnel').expand_path} is missing" unless File.exists?(tunnel)

    path = []


    host = File.open(tunnel, "r").gets.sub("\n", "")
    path << "#{protocol}://#{host}"

    path << url
    path.join('')
  end

end
