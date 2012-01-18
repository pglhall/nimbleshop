class CountryShippingZone < ShippingZone
  has_many  :region_shipping_zones
  validates :carmen_code, presence: true, carmen_country_code: true

  def country_code
    carmen_code && Carmen::Country.coded(carmen_code)
  end
end
