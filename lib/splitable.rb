class Splitable

  def self.url(order)
    submission_url = 'http://localhost:3000/split_payments/split?'
    data = {}
    data.merge!(title: 'The Black Eyed Peas: 20 Person Suite (End Zone)')
    data.merge!(item_type: 'fixed')
    data.merge!(total_amount: 20000)
    data.merge!(subdomain: 'southbeachseaplanes')
    data.merge!(order_id: order.id)
    data.merge!(number_of_participants: 20)
    data.merge!(notify_url: 'http://localhost:3010/payment_notifications/splitable')

    data.merge!(logo_url: 'https://s3.amazonaws.com/splitable-production1/app/public/system/logos/39/regular/sunlifestadium.gif')
    data.merge!(details_url: 'https://www.splitable.com/sunlife_stadium')
    data.merge!(item_image_url: 'https://s3.amazonaws.com/splitable-production1/app/public/system/images/126/regular/black-eyed-peas.jpg')
    submission_url + data.to_query
  end

end
