class RegionalShippingZone < ShippingZone

  belongs_to :country_shipping_zone

  validates :code, regional_code: true

  delegate :country_code, to: :country_shipping_zone, allow_nil: true
end
