class Shipment < ActiveRecord::Base
  attr_accessor :notify_customer

  belongs_to :shipment_carrier
  belongs_to :order

  def tracking_url
    case shipment_carrier.permalink
    when 'fedex'
      "http://www.fedex.com/Tracking?tracknumbers=#{tracking_number}"
    else
      "https://www.google.com/search?q=#{tracking_number}"
    end
  end

end
