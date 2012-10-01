# Instant Payment Notification (IPN) is posted by paypal to the notify_url . This IPN guarantees that the payment has been made. Hence it is
# utmost important that someone is not able to make a fake IPN notifcation. To verify IPN paypal provides two different types of validations
#  - Shared secrets for validations
#  - Using Postbacks valiation
#
#  Here we are going to use Postback validation. Here are are the rules for handling Postback validation.
#  - postback must be sent to https://www.paypal.com/cgi-bin/webscr.
#  - postback must include the variable cmd with the value _notify-validate. cmd=_notify-validate
#  - postback must include exactly the same variables and values that you receive in the IPN from PayPal, and they must be in the same order.
#  - PayPal responds to your postbacks with a single word in the body of the response: VERIFIED or INVALID.  When you receive a VERIFIED
#  postback response then perform further checks.
#  - Check that the payment_status is Completed.
#  - Check that the receiver_email is the merchant email address.
#  - Check that the price carried in mc_gross matches the total price of the order.
#
class PostbackValidation

  attr_reader :params, :order, :payment_method

  def initialize(params, order)
    @params = params.dup
    @order = order
    @payment_method = NimbleshopPaypalwp::Paypalwp.first
  end

  def valid?
    if payment_status_verified && receiver_email_verified && mc_gross_verified && postback_verified
      true
    else
      Rails.logger.info "Paypal postback validation failed. order was #{order.inspect}. params was #{params.inspect}"
    end
  end

  private

  def postback_verified
    true
  end

  def payment_status_verified
    if params[:payment_status] == 'Completed'
      true
    else
      Rails.logger.info "payment_status_verified failed. payment_status is #{params[:payment_status]}. It should be 'Completed'"
      false
    end
  end

  def receiver_email_verified
    if params[:business] == payment_method.merchant_email
      true
    else
      Rails.logger.info "params[:business] is #{params[:business]} . It should be #{payment_method.merchant_email}. "
      false
    end
  end

  def mc_gross_verified
    order_total_amount = order.total_amount.to_f.round(2).to_s
    if params[:mc_gross] == order_total_amount
      true
    else
      Rails.logger.info "params[:mc_gross] is #{params[:mc_gross]} and  order total amount is #{order_total_amount}"
      false
    end
  end

end
