class ShippingMethod < ActiveRecord::Base

  alias_attribute :shipping_cost,       :shipping_price
  alias_attribute :higher_price_limit,  :upper_price_limit

  belongs_to :shipping_zone

  validates_presence_of :lower_price_limit, :base_price, if: :country_level?
  validates_presence_of :name

  validates_numericality_of :lower_price_limit,
                            less_than: :higher_price_limit,
                            if: lambda { |r| r.country_level? && r.higher_price_limit },
                            allow_nil: true

  scope :active, where(active: true)

  scope :atleast, lambda { |r| 
    where('shipping_methods.lower_price_limit <= ?', r)
  }

  scope :atmost,  lambda { |r| 
    where('shipping_methods.upper_price_limit is null or shipping_methods.upper_price_limit >= ?', r)
  }

  scope :in_price_range,  lambda { |r| atleast(r).atmost(r) }

  scope :in_country, lambda { | code | 
    joins(:shipping_zone).where(shipping_zones: { country_code: code })
  }

  def self.in_state(state_code, country_code)
    where({
      shipping_zones: { 
        state_code: state_code, 
          country_shipping_zones_shipping_zones: { 
            country_code: country_code
        } 
      }
    }).joins(shipping_zone: :country_shipping_zone)
  end

  before_create :create_regional_shipping_methods, if: :country_level?
  before_save   :set_regions_inactive, if: :country_level?

  belongs_to  :parent,  class_name: 'ShippingMethod', foreign_key: 'parent_id'
  has_many    :regions, class_name: 'ShippingMethod', foreign_key: 'parent_id', dependent: :destroy

  # return shipping methods available to the given address for the given amount
  def self.available_for(amount, address)
    if address.state_code
      in_state(address.state_code, address.country_code)  
    else
      in_country(address.country_code)
    end.active.in_price_range(amount)
  end

  def self.available_for_countries(amount)
    active.in_price_range(amount).includes(:shipping_zone).map do | t |
      t.shipping_zone.country_code
    end.uniq
  end

  def shipping_price
    if country_level?
      base_price
    else
      parent.base_price + offset
    end
  end

  def country_level?
    shipping_zone.is_a?(CountryShippingZone)
  end

  def update_offset(value)
    value ||= 0
    value = value.to_f

    unless country_level?
      self.offset += value
      save
    end
  end

  def enable!
    update_attributes(active: true)
  end

  def disable!
    update_attributes(active: false)
  end

  private

  def create_regional_shipping_methods
    shipping_zone.regional_shipping_zones.each do |t|
      options = {shipping_zone: t, name: name, lower_price_limit: lower_price_limit,
                 upper_price_limit: upper_price_limit}
      if self.active == false
        options.merge!(active: false)
      end

      regions.build(options)
    end
  end

  def set_regions_inactive
    if self.persisted? && self.active_changed? && active == false
      regions.each { |region| region.update_attributes!(active: false) }
    end
  end
end
