class RegionalShippingZone < ShippingZone

  belongs_to :country_shipping_zone

  validates :code, carmen_region_code: true

  delegate :country_code, to: :country_shipping_zone, allow_nil: true

  def country?
    false
  end
end
