class ShippingZone < ActiveRecord::Base

  has_many :shipping_countries
  has_many :shipping_methods, dependent: :destroy

end
