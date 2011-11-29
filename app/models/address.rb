class Address < ActiveRecord::Base
  validates :first_name,  presence: true
  validates :last_name,   presence: true
  validates :address1,    presence: true
  validates :state,       presence: true
  validates :zip,         presence: true
  validates :country,     presence: true

  belongs_to :order
end

class ShippingAddress < Address
end

class BillingAddress < Address
end
