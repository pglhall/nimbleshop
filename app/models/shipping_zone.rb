class ShippingZone < ActiveRecord::Base
  include BuildPermalink
  has_many :shipping_methods, dependent: :destroy, conditions: { active: true }
end
