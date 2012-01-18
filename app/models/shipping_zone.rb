class ShippingZone < ActiveRecord::Base
  include BuildPermalink

  has_many :shipping_methods, dependent: :destroy, conditions: { active: true }

  validates :name,         presence: true
  validates :country_code, presence: true, carmen_country_code: true
end
