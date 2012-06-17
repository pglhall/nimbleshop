module PaymentMethodHelper

  def next_payment_processing_action(order)
    if pm = order.payment_method
      call_engineized_method(pm, :next_payment_processing_action, order)
    end
  end

  def order_show_extra_info(order)
    if pm = order.payment_method
      call_engineized_method(pm, :order_show_extra_info, order)
    end
  end

  def available_payment_options_icons
    PaymentMethod.order('id desc').map do |pm|
      call_engineized_method(pm, :available_payment_options_icons)
    end.compact.flatten
  end

  def icon_for_order_payment(order)
    if pm = order.payment_method
      call_engineized_method(pm,:icon_for_order_payment, order)
    end
  end

  def payment_info_for_buyer(order)
    if pm = order.payment_method
      call_engineized_method(pm, :payment_info_for_buyer, order)
    end
  end

  def nimbleshop_crud_form(payment_method)
    call_engineized_method(payment_method, :crud_form)
  end

  def engineized_name(payment_method, method_name)
    "nimbleshop_#{payment_method.demodulized_underscore}_#{method_name}".intern
  end

  def call_engineized_method(payment_method, method_name, *args)
    method_name_in_engine = engineized_name(payment_method, method_name)
    if self.respond_to?(method_name_in_engine)
      if args.any?
        self.send(method_name_in_engine, *args)
      else
        self.send(method_name_in_engine)
      end
    end
  end

end
