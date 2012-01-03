class Mailer < ActionMailer::Base
  include ApplicationHelper

  default :theme => "nootstrap"

  layout 'email'

  default :from => Settings.from_email
  default_url_options[:host] = Settings.host_for_email
  #default_url_options[:protocol] = Settings.using_heroku ? 'https' : 'http'

  def receipt(order_number)
    subject = "Receipt for sale"

    # TODO ideally I should be able to use current_shop below
    @shop = Shop.first

    @order = Order.find_by_number!(order_number)
    mail_options = {:to => @order.email, :subject => subject}

    mail(mail_options)
  end

end
