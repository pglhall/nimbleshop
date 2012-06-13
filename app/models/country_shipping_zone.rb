class CountryShippingZone < ShippingZone

  has_many      :regional_shipping_zones, dependent: :destroy

  validates     :country_code,  presence: true
  validate      :code_validity

  before_save   :set_name,      if: :country_code_changed?
  after_create  :create_regions

  def country
    Carmen::Country.coded(country_code)
  end

  def self.all_country_codes
    CountryShippingZone.pluck(:country_code)
  end

  private

  def code_validity
    unless country
      errors.add(:country_code, "is invalid")
    end
  end

  def create_regions
    country.subregions.each do | region |
      regional_shipping_zones.create({ state_code: region.code, country_code: country_code })
    end
  end

  def set_name
    self.name = country.name
  end
end
