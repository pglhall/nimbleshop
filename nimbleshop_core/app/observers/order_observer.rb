class OrderObserver < ActiveRecord::Observer

  # All the methods listed below get transition object as the second
  # parameter. It is an instance of +StateMachine::Transition+.
  #
  # p transition.to => 'pending'
  # p transition.from => 'abandoned'
  # p transition.event => :pending
  # p transition => #<StateMachine::Transition attribute=:payment_status event=:pending from="abandoned" from_name=:abandoned to="pending" to_name=:pending>
  #

  #
  # Ideally what to do after state transition should be pushed to
  # individual payment method. In this way we will not have the if
  # condition that we are seeing in after_pending .
  #

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

  def after_pending(order, transition)
    if order.payment_method.is_a? NimbleshopCod::Cod
      Mailer.delay.order_notification_to_buyer(order.number)
      AdminMailer.delay.new_order_notification(order.number)
    end

    order.shipping_pending
  end

  def after_void(order, transition)
  end

  def after_refund(order, transition)
  end

end
