require 'active_merchant/billing/integrations/action_view_helper'

module PaymentMethodHelper
  include ActiveMerchant::Billing::Integrations::ActionViewHelper

  def order_show_extra_info(order)
    if pm = order.payment_method
      call_engineized_method(pm, :order_show_extra_info)
    end
  end

  def available_payment_options_icons
    PaymentMethod.order('id desc').map do |pm|
      call_engineized_method(pm, :available_payment_options_icons)
    end.compact.flatten
  end

  def icon_for_order_payment(order)
    if pm = order.payment_method
      call_engineized_method(pm,:icon_for_order_payment)
    end
  end

  def payment_info_for_buyer(order)
    if pm = order.payment_method
      call_engineized_method(pm, :payment_info_for_buyer)
    end
  end

  def nimbleshop_crud_form(payment_method)
    call_engineized_method(payment_method, :crud_form)
  end

  def engineized_name(payment_method, method_name)
    "nimbleshop_#{payment_method.demodulized_underscore}_#{method_name}".intern
  end

  def call_engineized_method(payment_method, method_name)
    ethod_name_in_engine = engineized_name(payment_method, method_name)
    self.send(m) if self.respond_to?(m)
  end

end
