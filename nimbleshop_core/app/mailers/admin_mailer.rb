class AdminMailer < ActionMailer::Base

  include ApplicationHelper

  default from: lambda { Shop.current.from_email }

  # for some mysterious reason travis ci loads this file while
  # generating the test app and it finds that Nimbleshop.config is nil
  # and the code blows up. The temporary fix is to use respond_to?
  default_url_options[:host]     = Nimbleshop.respond_to?(:config) && Nimbleshop.config.bare_url_with_port

  default_url_options[:protocol] = 'http'

  def new_order_notification(order_number)
    @order = Order.find_by_number!(order_number)
    @shop = Shop.current
    @payment_date = @order.purchased_at

    mail_options = { to: @order.email, subject: "Order ##{order_number} was recently placed" }

    mail(mail_options) do |format|
      format.text { render "admin/mailer/new_order_notification" }
    end
  end

end
