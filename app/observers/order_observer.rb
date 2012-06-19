class OrderObserver < ActiveRecord::Observer

  # TODO send_email_notification is a very generic name
  def after_purchase(order, transition)
    send_email_notifications(order)
    order.mark_as_purchased!
    order.shipping_pending
    ActiveSupport::Notifications.instrument("order.purchased", order.number)
  end

  # TODO send_email_notification is a very generic name
  def after_authorize(order, transition)
    send_email_notifications(order)
    order.mark_as_purchased!
    order.shipping_pending
  end

  def after_kapture(order, transition)
  end

  def after_void(order, transition)
  end

  def after_refund(order, transition)
  end

  private

  # TODO  If a person pays using credit card then that person will receive the order
  # notification twice. 
  def send_email_notifications(order)
    Mailer.delay.order_notification(order.number)
    AdminMailer.delay.new_order_notification(order.number)
  end

end
