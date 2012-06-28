class ShippingMethod < ActiveRecord::Base

  alias_attribute :shipping_cost,       :shipping_price
  alias_attribute :higher_price_limit,  :maximum_order_amount

  belongs_to :shipping_zone

  validates_presence_of :minimum_order_amount, :base_price, if: :country_level?
  validates_presence_of :name

  validates_numericality_of :minimum_order_amount,
                            less_than: :higher_price_limit,
                            if: lambda { |r| r.country_level? && r.higher_price_limit && (r.higher_price_limit > 0 ) },
                            message: '^ Maximum order amount must be greater than 0',
                            allow_nil: true

  validates_numericality_of :maximum_order_amount,
                            greater_than: 0,
                            if: lambda { |r| r.country_level? },
                            allow_nil: true


  scope :active, where(active: true)

  scope :atleast, lambda { |r| where('shipping_methods.minimum_order_amount <= ?', r) }

  scope :atmost,  lambda { |r| where('shipping_methods.maximum_order_amount is null or shipping_methods.maximum_order_amount >= ?', r) }

  scope :in_price_range,  lambda { |r| atleast(r).atmost(r) }

  scope :in_country, lambda { |country_code| joins(:shipping_zone).where(shipping_zones: { country_code: country_code }) }

  def self.in_state(state_code, country_code)
    where({
      shipping_zones: { state_code: state_code },
      country_shipping_zones_shipping_zones: { country_code: country_code }
    }).joins(shipping_zone: :country_shipping_zone)
  end

  before_create :create_regional_shipping_methods, if: :country_level?

  before_save   :update_regions_status, if: :country_level?

  belongs_to  :parent,  class_name: 'ShippingMethod', foreign_key: 'parent_id'
  has_many    :regions, class_name: 'ShippingMethod', foreign_key: 'parent_id', dependent: :destroy

  # returns shipping methods available for the given address and for the given amount
  def self.available_for(amount, address)
    a = address.state_code ? in_state(address.state_code, address.country_code) : in_country(address.country_code)
    a.active.in_price_range(amount)
  end

  def self.available_for_countries(amount)
    active.in_price_range(amount).includes(:shipping_zone).map { |t| t.shipping_zone.country_code }.uniq
  end

  def shipping_price
    country_level? ? base_price : (parent.base_price + offset)
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
      options = { shipping_zone: t, 
                  name: name, 
                  minimum_order_amount: minimum_order_amount,
                  maximum_order_amount: maximum_order_amount }

      options.merge!(active: false) unless active
      regions.build(options)
    end
  end

  def update_regions_status
    if persisted? && active_changed? && active == false
      regions.each { |region| region.update_attributes!(active: false) }
    end
  end

end
