class OrderObserver < ActiveRecord::Observer

  def after_purchase(order, transition)
    send_email_notifications(order)
    order.mark_as_paid!
    order.shipping_pending
  end

  def after_authorize(order, transition)
    send_email_notifications(order)
    order.mark_as_paid!
    order.shipping_pending
  end

  def after_kapture(order, transition)
  end

  def after_void(order, transition)
  end

  def after_refund(order, transition)
  end

  private

  def send_email_notifications(order)
    Mailer.delay.order_notification(order.number)
    AdminMailer.delay.new_order_notification(order.number)
  end

end
