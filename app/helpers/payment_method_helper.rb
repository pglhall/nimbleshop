require 'active_merchant/billing/integrations/action_view_helper'

module PaymentMethodHelper
  include ActiveMerchant::Billing::Integrations::ActionViewHelper

  def order_show_extra_info(order)
    if pm = order.payment_method
      m = engineized_name(pm, :order_show_extra_info)
      self.send(m, order) if self.respond_to?(m)
    end
  end

  def engineized_name(payment_method, method_name)
    "nimbleshop_#{payment_method.demodulized_underscore}_#{method_name}".intern
  end

  def available_payment_options_icons
    PaymentMethod.order('id desc').map do |pm|
      m = engineized_name(pm, :available_payment_options_icons)
      self.send(m) if self.respond_to?(m)
    end.compact.flatten
  end

  def icon_for_order_payment(order)
    if pm = order.payment_method
      m = engineized_name(pm,:icon_for_order_payment)
      self.send(m, order) if self.respond_to?(m)
    end
  end

  def payment_info_for_buyer(order)
    if pm = order.payment_method
      m = engineized_name(pm, :payment_info_for_buyer)
      self.send(m , order) if self.respond_to?(m)
    end
  end

  def nimbleshop_crud_form(payment_method)
    self.send( engineized_name(payment_method, :crud_form) )
  end


end
