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

  before_create :create_regional_shipping_methods, :if => :country_level?

  belongs_to  :parent,  class_name: 'ShippingMethod', foreign_key: 'parent_id'
  has_many    :regions, class_name: 'ShippingMethod', foreign_key: 'parent_id'

  # return shipping methods available to the given address for the given amount
  def self.available_for(amount, shipping_address)
    country_code = shipping_address.country_code
    state_code   = shipping_address.state_code

    if state_code
      scoped = self.scoped.where("? >= lower_price_limit", amount).where("? <= upper_price_limit", amount)
      scoped = scoped.joins(:shipping_zone).where(shipping_zones: {country_code: shipping_address.country_code})
      scoped = scoped.where(shipping_zones: {state_code: shipping_address.state_code})
      scoped.all
    else
      scope = CountryShippingZone.where(country_code: country_code)
      scope.where("lower_price_limit >= #{amount}").where("uppper_price_limit <= #{amount}")
    end
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
      regions.build(shipping_zone: t,
                    name: name,
                    lower_price_limit: lower_price_limit,
                    upper_price_limit: upper_price_limit)
    end
  end
end
