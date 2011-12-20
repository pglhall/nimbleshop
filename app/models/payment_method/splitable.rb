class PaymentMethod::Splitable < PaymentMethod

  attr_accessor :api_key

  def url(order, request)

    submission_url = 'http://localhost:3000/split_payments/split?'
    submission_url = 'http://lvh.me:3000/split_payments/split?'
    data = {}

    data.merge!(api_key: self.api_key)
    data.merge!(title: 'iPad')
    data.merge!(total_amount: 50000)
    data.merge!(invoice: order.number)
    data.merge!(api_secret: 'sdfs9smdsddf')
    data.merge!(details_url: 'http://www.apple.com/pr/products/ipad/ipad.html')

    t = request.protocol + request.host_with_port + '/payment_notifications/splitable'
    Rails.logger.info t
    data.merge!(api_notify_url: t)

    data.merge!(logo_url: 'http://edibleapple.com/wp-content/uploads/2009/04/silver-apple-logo.png')
    data.merge!(product_picture_url: 'http://cdn.tipb.com/images/stories/2010/01/ipad.png')
    data.merge!(expires_in: 24)

    Rails.logger.info data.inspect

    submission_url + data.to_query
  end

  private

  def set_data
    self.data = {api_key: @api_key}
  end

end
