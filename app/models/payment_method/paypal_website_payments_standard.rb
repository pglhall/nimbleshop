class PaymentMethod::PaypalWebsitePaymentsStandard < PaymentMethod

  store_accessor  :settings,
                  :paypal_website_payments_standard_merchant_email_address,
                  :paypal_website_payments_standard_return_url,
                  :paypal_website_payments_standard_notify_url,
                  :paypal_website_payments_standard_request_submission_url

  def url(order)
    data = {
      business: self.paypal_website_payments_standard_merchant_email_address,
      cmd: '_cart',
      upload: 1,
      return: self.paypal_website_payments_standard_return_url,
      invoice: order.number,
      secret:  'xxxxxxx', #TODO this should be stored and verified later
      notify_url: self.paypal_website_payments_standard_notify_url
    }

    order.line_items.each_with_index do |item, index|
      data.merge!({
        "amount_#{index+1}"      => item.product.price,
        "item_name_#{index+1}"   => item.product.name,
        "item_number_#{index+1}" => item.id,
        "quantity_#{index+1}"    => item.quantity
      })
    end
    final_url = self.paypal_website_payments_standard_request_submission_url + values.to_query
    Rails.logger.info "final_url: #{final_url}"
    final_url
  end

end
