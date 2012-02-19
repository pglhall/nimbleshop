class RegionalShippingZone < ShippingZone

  validates :state_code, presence: true

  validate :code_validity

  before_save :set_name

  delegate :country, to: :country_shipping_zone, allow_nil: true

  private

  def code_validity
    country = country_shipping_zone.country
    unless country.subregions.coded(state_code)
      self.errors.add(:code, "#{state_code} is an invalid regional code for country #{country.name}")
    end
  end

  def set_name
    country = country_shipping_zone.country
    self.name = country.subregions.coded(state_code).name
  end
end