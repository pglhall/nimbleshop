# TODO move it to observers directory
#
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
    Mailer.order_notification(order.number).deliver
    AdminMailer.new_order_notification(order.number).deliver
  end

end
