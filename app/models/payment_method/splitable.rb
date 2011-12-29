Order.class_eval do
  preference :api_secret,     :string
end

class PaymentMethod::Splitable < PaymentMethod

  preference :api_key,     :string
  preference :api_secret,     :string
  preference :submission_url, :string
  preference :logo_url,       :string
  preference :expires_in,     :string


  def url(order, request)
    product = order.line_items.first.product

    data = {}

    data.merge!(api_key: self.preferred_api_key)
    data.merge!(title: product.name)
    data.merge!(total_amount: (order.grand_total*100).to_i)
    data.merge!(invoice: order.number)

    api_secret = ActiveSupport::SecureRandom.hex(10)
    order.write_preference(:api_secret, api_secret)
    order.save

    data.merge!(api_secret: api_secret)
    data.merge!(details_url: request.protocol + request.host_with_port + "/products/#{product.permalink}")

    t = request.protocol + request.host_with_port + '/payment_notifications/splitable'
    Rails.logger.info t
    data.merge!(api_notify_url: t)

    data.merge!(logo_url: self.preferred_logo_url)
    data.merge!(product_picture_url: request.protocol + request.host_with_port + product.picture.picture_url(:small))

    data.merge!(expires_in: self.preferred_expires_in)

    Rails.logger.info data.to_yaml

    self.preferred_submission_url + data.to_query
  end

end
