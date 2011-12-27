class PaymentMethod::PaypalWebsitePaymentsStandard < PaymentMethod

  attr_accessor :merchant_email_address, :return_url, :notify_url, :request_submission_url

  def url(order)
    values = {
      :business => merchant_email_address,
      :cmd => '_cart',
      :upload => 1,
      :return => return_url,
      :invoice => order.number,
      :secret  => 'xxxxxxx', #TODO this should be stored and verified later
      :notify_url => notify_url
    }
    order.line_items.each_with_index do |item, index|
      values.merge!({
        "amount_#{index+1}"      => item.product.price,
        "item_name_#{index+1}"   => item.product.name,
        "item_number_#{index+1}" => item.id,
        "quantity_#{index+1}"    => item.quantity
      })
    end
    request_submission_url + values.to_query
  end

  private


  def set_data
    self.data = { merchant_email_address: @merchant_email_address,
                  return_url: @return_url,
                  notify_url: @notify_url,
                  request_submission_url: @request_submission_url }
  end

end
