Order.class_eval do
  store_accessor :settings, :splitable_api_secret, :splitable_transaction_number
end

class PaymentMethod::Splitable < PaymentMethod

  store_accessor :settings, :splitable_api_key, :splitable_api_secret, :splitable_submission_url,
                              :splitable_logo_url, :splitable_expires_in

  def process_request(order, request)
    conn = Faraday.new(:url => self.splitable_submission_url) do |builder|
      builder.use Faraday::Request::UrlEncoded  # convert request params as "www-form-urlencoded"
      builder.use Faraday::Response::Logger     # log the request to STDOUT
      builder.use Faraday::Adapter::NetHttp     # make http requests with Net::HTTP
    end

    options = base_data(order, request).merge(line_items_data(order, request))

    msg = "splitable_submission_url: #{self.splitable_submission_url} . options: #{options.inspect}"
    Rails.logger.info msg

    response = conn.post '/api/splits', options
    data = ActiveSupport::JSON.decode(response.body)
    data['error'].blank? ? [nil, data['success']] : [data['error'], nil]
  end

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
        "amount_#{index}"      => (item.price * 100).to_i,
        "item_name_#{index}"   => item.title,
        "quantity_#{index}"    => item.quantity,
        "url_#{index}"         => request.protocol + request.host_with_port + "/products/#{item.product_permalink}"
      })
    end
    data
  end

end
