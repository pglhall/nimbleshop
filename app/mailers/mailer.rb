class Mailer < ActionMailer::Base
  helper :frontend

  default :theme => "nootstrap"

  layout 'email'

  default :from => lambda { Shop.first.from_email }
  default_url_options[:host] = Settings.host_for_email
  default_url_options[:protocol] = 'http'

  def order_notification(order_number)
    subject = "Order confirmation for order ##{order_number}"
    @order = Order.find_by_number!(order_number)

    # TODO ideally I should be able to use current_shop below
    @shop = Shop.first

    # TODO ideally it should be the other way round gut creating creditcard_transaction record
    # is a bit difficult in test. should be fixed soon
    @payment_date = @order.created_at.to_s(:long) || @order.paid_at.to_s(:long)

    mail_options = {to: @order.email, subject: subject}
    mail(mail_options)
  end

  def shipping_notification(order_number)
    subject = "Items for order ##{order_number} have been shipped"
    @order = Order.find_by_number!(order_number)
    @shipment = @order.shipments.first

    mail_options = {to: @order.email, subject: subject}
    mail(mail_options)
  end

end
