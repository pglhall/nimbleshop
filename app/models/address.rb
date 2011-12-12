class Address < ActiveRecord::Base
  validates :first_name,  presence: true
  validates :last_name,   presence: true
  validates :address1,    presence: true
  validates :state,       presence: true
  validates :zip,         presence: true
  validates :country,     presence: true

  belongs_to :order

  def full_address_array
    [name, address1, address2, city_state_zip].compact
  end

  def name
    [first_name, last_name].compact.join(' ')
  end

  def address_lines(join_chars = ', ')
    [address1, address2].delete_if{|add| add.blank?}.join(join_chars)
  end

  def city_state_name
    [city, state].join(', ')
  end

  def city_state_zip
    [city_state_name, zip].join(' ')
  end

end

class ShippingAddress < Address
end

class BillingAddress < Address
end
