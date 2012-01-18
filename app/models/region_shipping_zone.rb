class RegionShippingZone < ShippingZone
  belongs_to :country_shipping_zone

  validates :carmen_code, carmen_region_code: true

  delegate :country_code, to: :country_shipping_zone, allow_nil: true
end
