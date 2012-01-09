class PaymentMethod::PaypalWebsitePaymentsStandard < PaymentMethod

  preference :merchant_email_address, :string
  preference :return_url,             :string
  preference :notify_url,             :string
  preference :request_submission_url, :string

  def url(order)
    values = {
      business: self.preferred_merchant_email_address,
      cmd: '_cart',
      upload: 1,
      return: self.preferred_return_url,
      invoice: order.number,
      secret:  'xxxxxxx', #TODO this should be stored and verified later
      notify_url: self.preferred_notify_url
    }

    order.line_items.each_with_index do |item, index|
      values.merge!({
        "amount_#{index+1}"      => item.product.price,
        "item_name_#{index+1}"   => item.product.name,
        "item_number_#{index+1}" => item.id,
        "quantity_#{index+1}"    => item.quantity
      })
    end
    self.preferred_request_submission_url + values.to_query
  end

end
