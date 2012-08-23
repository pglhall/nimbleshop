module Order::PaymentTransitions

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

  def after_purchase(transition)
    self.mark_as_purchased!

    # do not use bang version because the order might already bbe in shipping_pending state. That is possible
    # if user used splitable in which case the order is put in shipping_pending state in pending state.
    self.shipping_pending

    ActiveSupport::Notifications.instrument("order.purchased", { order_number: number } )

    mailer = Nimbleshop.config.mailer.constantize
    mailer.delay.order_notification_to_buyer(number)
    AdminMailer.delay.new_order_notification(number)
  end

  def after_authorize(transition)
    mailer = Nimbleshop.config.mailer.constantize
    mailer.delay.order_notification_to_buyer(number)
    AdminMailer.delay.new_order_notification(number)

    mark_as_purchased!
    shipping_pending!
  end

  def after_kapture(order, transition)
  end

  def after_pending(transition)
    if payment_method.is_a? NimbleshopCod::Cod
      mailer = Nimbleshop.config.mailer.constantize
      mailer.order_notification_to_buyer(number).deliver
      AdminMailer.delay.new_order_notification(number)
    end

    mark_as_purchased!
    shipping_pending!
  end

  def after_void(order, transition)
  end

  def after_refund(order, transition)
  end

end
