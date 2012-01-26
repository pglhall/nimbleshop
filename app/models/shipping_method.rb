class ShippingMethod < ActiveRecord::Base

  alias_attribute :shipping_cost,       :base_price
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

  # indicates if the shipping method is available for the given order
  def available_for(order)
    if upper_price_limit
      (order.amount >= (lower_price_limit || parent.lower_price_limit)) && (order.amount <= upper_price_limit)
    else
      order.amount >= (lower_price_limit || parent.lower_price_limit)
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

  private

  def create_regional_shipping_methods
    shipping_zone.regional_shipping_zones.each do |t|
      regions.build(shipping_zone: t, name: name)
    end
  end
end
