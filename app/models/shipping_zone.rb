class ShippingZone < ActiveRecord::Base
  include BuildPermalink
  has_many :shipping_methods, dependent: :destroy, conditions: { active: true }

  def regions?
    respond_to?(:regional_shipping_zones)
  end
end
