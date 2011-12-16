class PaymentMethod::Splitable < PaymentMethod

  attr_accessor :api_key

  def url(order)
    submission_url = 'http://localhost:3000/split_payments/split?'
    data = {}

    data.merge!(api_key: self.api_key)
    data.merge!(title: 'The Black Eyed Peas: 20 Person Suite (End Zone)')
    data.merge!(total_amount: 20000)
    data.merge!(invoice: order.id)
    data.merge!(number_of_participants: 20)
    data.merge!(api_secret: 'sdfs9smdsddf')
    data.merge!(details_url: 'https://www.splitable.com/sunlife_stadium')

    data.merge!(logo_url: 'https://s3.amazonaws.com/splitable-production1/app/public/system/logos/39/regular/sunlifestadium.gif')
    data.merge!(item_image_url: 'https://s3.amazonaws.com/splitable-production1/app/public/system/images/126/regular/black-eyed-peas.jpg')
    data.merge!(expires_in: 24)

    submission_url + data.to_query
  end

  private

  def set_data
    self.data = {api_key: @api_key}
  end

end
