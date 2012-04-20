class ShippingZone < ActiveRecord::Base

  include Permalink::Builder

  has_many :shipping_methods, dependent: :destroy, conditions: { active: true }

  belongs_to :country_shipping_zone
end
