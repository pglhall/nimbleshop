class Mailer < ActionMailer::Base
  include ApplicationHelper

  default :theme => "nootstrap"

  layout 'email'

  default :from => Settings.from_email
  default_url_options[:host] = Settings.host_for_email
  default_url_options[:protocol] = 'http'

  def order_notification(order_number)
    subject = "Order confirmation for order ##{order_number}"
    @order = Order.find_by_number!(order_number)

    # TODO ideally I should be able to use current_shop below
    @shop = Shop.first
    @payment_date = @order.creditcard_transactions.first.created_at.to_s(:long)

    mail_options = {:to => @order.email, :subject => subject}
    mail(mail_options)
  end

  def shipping_notification(order_number)
    subject = "Items for order ##{order_number} have been shipped"
    @order = Order.find_by_number!(order_number)

    mail_options = {:to => @order.email, :subject => subject}
    mail(mail_options)
  end

end
