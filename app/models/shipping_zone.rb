class ShippingZone < ActiveRecord::Base

  include BuildPermalink

  has_many :shipping_methods, dependent: :destroy, conditions: { active: true }

  belongs_to :country_shipping_zone
end

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
