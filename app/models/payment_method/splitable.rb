Order.class_eval do
  store_accessor :settings, :splitable_api_secret, :splitable_transaction_number, :splitable_paid_at
end

class PaymentMethod::Splitable < PaymentMethod

  store_accessor :settings, :splitable_api_key,
                            :splitable_api_secret,
                            :splitable_submission_url,
                            :splitable_logo_url,
                            :splitable_expires_in

  attr_accessor :order, :request

  def process_request(order, request)
    self.order   = order
    self.request = request

    conn = build_connection
    options = base_data.merge(line_items_data)

    Rails.logger.info "splitable_submission_url: #{self.splitable_submission_url} . options: #{options.inspect}"

    response = conn.post '/api/splits', options
    Rails.logger.info "response.body is #{response.body}"

    data = ActiveSupport::JSON.decode(response.body)
    data['error'].blank? ? [nil, data['success']] : [data['error'], nil]
  end

  def validate_splitable_webhook(params)
    order = Order.find_by_number(params[:invoice])

    return "Invoice number #{params[:invoice]} does not match}" if order.blank?
    return "Parameter api_secret does not match" unless order.splitable_api_secret == params[:api_secret]
    return "Parameter payment_status is blank" if params[:payment_status].blank?
    return "transaction_id is blank" if params[:transaction_id].blank?

    unless %w(paid cancelled).include? params[:payment_status]
      return "Parameter payment_status must be 'paid' or 'cancelled'. It was #{params[:payment_status]}"
    end

    payment_status = params[:payment_status] == 'paid' ? 'purchased' : 'cancelled'

    if order.update_attributes( payment_method: self, splitable_transaction_number: params[:transaction_id])
      order.send(payment_status)
      nil
    else
      return order.errors.full_messages.to_sentence
    end
  end

  private

  def base_data
    order.splitable_api_secret = SecureRandom.hex(10)
    order.save!

    #api_notify_url = request.protocol + request.host_with_port + '/instant_payment_notifications/splitable'
    api_notify_url = 'http://' + request.host_with_port + '/instant_payment_notifications/splitable'

    { api_key:        self.splitable_api_key,
      total_amount:   (order.total_amount * 100).to_i,
      invoice:        order.number,
      api_secret:     order.splitable_api_secret,
      api_notify_url: api_notify_url,
      shipping:       (order.shipping_method.shipping_cost * 100).to_i,
      expires_in:     self.splitable_expires_in}
  end

  def line_items_data
    data = {}
    order.line_items.each_with_index do |item, i|
      index = i + 1
      data.merge!({
        "amount_#{index}"      => (item.price * 100).to_i,
        "item_name_#{index}"   => item.product_name,
        "quantity_#{index}"    => item.quantity,
        "url_#{index}"         => request.protocol + request.host_with_port + "/products/#{item.product_permalink}"
      })
    end
    data
  end

  def build_connection
    Faraday.new(:url => self.splitable_submission_url) do |builder|
      builder.use Faraday::Request::UrlEncoded  # convert request params as "www-form-urlencoded"
      builder.use Faraday::Response::Logger     # log the request to STDOUT
      builder.use Faraday::Adapter::NetHttp     # make http requests with Net::HTTP
    end
  end

end
