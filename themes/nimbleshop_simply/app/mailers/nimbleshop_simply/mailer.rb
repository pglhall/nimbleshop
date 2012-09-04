module NimbleshopSimply
  class Mailer < ActionMailer::Base

    helper :application

    layout 'nimbleshop_simply/mailer'

    default from: lambda { Shop.current.from_email }

    # for some mysterious reason travis ci loads this file while
    # generating the test app and it finds that Nimbleshop.config is nil
    # and the code blows up. The temporary fix is to use respong_to?
    default_url_options[:host] = Nimbleshop.respond_to?(:config) && Nimbleshop.config.bare_url_with_port

    default_url_options[:protocol] = 'http'

    def order_notification_to_buyer(order_number)
      subject = "Order confirmation for order ##{order_number}"
      @order = Order.find_by_number!(order_number)

      @shop = Shop.current
      @payment_date = @order.created_at.to_s(:long) || @order.purchased_at.to_s(:long)

      mail_options = {to: @order.email, subject: subject}
      mail(mail_options)

    end

    def shipment_notification_to_buyer(order_number)
      subject = "Items for order ##{order_number} have been shipped"
      @order = Order.find_by_number!(order_number)
      @shipment = @order.shipments.first

      mail_options = {to: @order.email, subject: subject}
      mail(mail_options)
    end

  end
 end
