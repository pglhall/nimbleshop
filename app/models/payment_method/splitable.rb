Order.class_eval do
  store_accessor :settings, :splitable_api_secret, :splitable_transaction_number
end

class PaymentMethod::Splitable < PaymentMethod

  store_accessor :settings, :splitable_api_key, :splitable_api_secret, :splitable_submission_url,
                              :splitable_logo_url, :splitable_expires_in

  def base_data(order, request)
    order.splitable_api_secret = SecureRandom.hex(10)
    order.save

    product = order.line_items.first.product
    #api_notify_url = request.protocol + request.host_with_port + '/instant_payment_notifications/splitable'
    api_notify_url = 'http://' + request.host_with_port + '/instant_payment_notifications/splitable'

    { api_key: self.splitable_api_key,
      total_amount: (order.grand_total*100).to_i,
      invoice: order.number,
      api_secret: order.splitable_api_secret,
      api_notify_url: api_notify_url,
      shipping: (order.shipping_method.shipping_cost * 100).to_i,
      expires_in: self.splitable_expires_in}
  end

  def line_items_data(order, request)
    data = {}
    order.line_items.each_with_index do |item, i|
      index = i + 1
      data.merge!({
        "amount_#{index}"      => (item.product.price * 100).to_i,
        "item_name_#{index}"   => item.product.name,
        "quantity_#{index}"    => item.quantity,
        "url_#{index}"           => request.protocol + request.host_with_port + "/products/#{item.product.permalink}"
      })
    end
    data
  end

end
