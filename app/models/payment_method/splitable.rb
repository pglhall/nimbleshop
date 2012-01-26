Order.class_eval do
  store_accessor :settings, :splitable_api_secret
end

class PaymentMethod::Splitable < PaymentMethod

  store_accessor :settings, :splitable_api_key, :splitable_api_secret, :splitable_submission_url,
                              :splitable_logo_url, :splitable_expires_in

  def url(order, request)
    product = order.line_items.first.product

    data = {}

    data.merge!(api_key: self.splitable_api_key)
    data.merge!(title: product.name)
    data.merge!(total_amount: (order.grand_total*100).to_i)
    data.merge!(invoice: order.number)

    api_secret = ActiveSupport::SecureRandom.hex(10)
    order.splitable_api_secret = api_secret
    order.save

    data.merge!(api_secret: api_secret)
    data.merge!(details_url: request.protocol + request.host_with_port + "/products/#{product.permalink}")

    t = request.protocol + request.host_with_port + '/payment_notifications/splitable'
    Rails.logger.info t
    data.merge!(api_notify_url: t)

    data.merge!(logo_url: self.splitable_logo_url)
    data.merge!(product_picture_url: request.protocol + request.host_with_port + product.picture.picture_url(:small))

    data.merge!(expires_in: self.splitable_expires_in)

    Rails.logger.info data.to_yaml

    self.splitable_submission_url + data.to_query
  end

end
