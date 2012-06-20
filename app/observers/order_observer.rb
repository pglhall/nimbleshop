class OrderObserver < ActiveRecord::Observer

  def after_purchase(order, transition)
    Mailer.delay.order_notification_to_buyer(order.number)
    AdminMailer.delay.new_order_notification(order.number)

    order.mark_as_purchased!
    order.shipping_pending
    ActiveSupport::Notifications.instrument("order.purchased", { order_number: order.number } )
  end

  def after_authorize(order, transition)
    Mailer.delay.order_notification_to_buyer(order.number)
    AdminMailer.delay.new_order_notification(order.number)
    order.mark_as_purchased!
    order.shipping_pending
  end

  def after_kapture(order, transition)
  end

  def after_void(order, transition)
  end

  def after_refund(order, transition)
  end

end
