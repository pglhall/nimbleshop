class CountryShippingZone < ShippingZone

  has_many  :regional_shipping_zones do
    def create_by_carmen(carmen)
      create(name: carmen.name, code: carmen.code)
    end
  end

  before_validation :assign_name, unless: :name, if: :code

  validates :code, presence: true, carmen_country_code: true

  after_create :create_regions

  def country_code
    @_country_code ||= self.class.to_carmen_country(code)
  end

  def self.to_carmen_country(code)
    Carmen::Country.coded(code)
  end

  def self.create_by_carmen_code(carmen_code)
    country = to_carmen_country(carmen_code)
    country && create(name: country.name, code: carmen_code)
  end

  def country?
    true
  end


  private

  def create_regions
    country_code.subregions.each do | r | 
      regional_shipping_zones.create_by_carmen(r)
    end
  end

  def assign_name
    @_country_code = nil

    if country_code
      self.name = country_code.name
    end
  end
end
