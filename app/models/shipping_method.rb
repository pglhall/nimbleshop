class ShippingMethod < ActiveRecord::Base

  belongs_to :shipping_zone

  validates :lower_price_limit, presence: true
  validates :shipping_price,    presence: true

end
