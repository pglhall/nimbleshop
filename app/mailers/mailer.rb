class Mailer < ActionMailer::Base
  helper :frontend

  default theme: "simply"

  layout 'email'

  default from: lambda { Shop.first.from_email }
  default_url_options[:host] = Settings.host_for_email
  default_url_options[:protocol] = 'http'

  def order_notification_to_buyer(order_number)
    subject = "Order confirmation for order ##{order_number}"
    @order = Order.find_by_number!(order_number)

    @shop = Shop.first
    @payment_date = @order.created_at.to_s(:long) || @order.purchased_at.to_s(:long)

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
