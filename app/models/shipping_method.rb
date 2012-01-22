class ShippingMethod < ActiveRecord::Base

  alias_attribute :higher_price_limit,  :upper_price_limit
  alias_attribute :shipping_cost,       :shipping_price

  belongs_to :shipping_zone

  validates_presence_of     :lower_price_limit, :shipping_price, :name

  validates_numericality_of :lower_price_limit, 
                            less_than: :higher_price_limit, 
                            if: :higher_price_limit,
                            allow_nil: true

  scope :active, where(active: true)

  after_create :create_regional

  # indicates if the shipping method is available for the given order
  def available_for(order)
    if upper_price_limit
      (order.amount >= lower_price_limit) && (order.amount <= upper_price_limit)
    else
      order.amount >= lower_price_limit
    end
  end

  def create_regional
    if shipping_zone.regions?
      shipping_zone.regional_shipping_zones.each do | zone |
        clone_for_region.tap { |t| t.shipping_zone = zone }.save
      end
    end
  end

  private

  def clone_for_region
    copy_attributes = %w(lower_price_limit upper_price_limit shipping_price name)
    ShippingMethod.new(attributes.slice(*copy_attributes))
  end
end
