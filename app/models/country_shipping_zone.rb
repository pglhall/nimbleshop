class CountryShippingZone < ShippingZone

  has_many  :regional_shipping_zones

  before_save :set_name

  validates_presence_of :country_code
  validate :code_validity

  after_create :create_regions

  def country
    Carmen::Country.coded(country_code)
  end

  private

  def code_validity
    unless country
      self.errors.add(:country_code, "is invalid")
    end
  end

  def create_regions
    country.subregions.each do | r |
      regional_shipping_zones.create(state_code: r.code, country_code: country_code)
    end
  end

  def set_name
    self.name = country.name
  end

end
