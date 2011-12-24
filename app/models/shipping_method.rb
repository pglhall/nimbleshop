class ShippingMethod < ActiveRecord::Base

  alias_attribute :higher_price_limit, :upper_price_limit

  belongs_to :shipping_zone

  scope :active, where(active: true)

  validates :lower_price_limit, presence: true
  validates :shipping_price,    presence: true
  validates :name,              presence: true
  validate :lower_price_limit_should_be_lower_than_higher_price_limit

  alias_attribute :shipping_cost, :shipping_price

  # indicates if the shipping method is available for the given order
  def available_for(order)
    if upper_price_limit
      (order.amount >= lower_price_limit) && (order.amount <= upper_price_limit)
    else
      order.amount >= lower_price_limit
    end
  end

  def lower_price_limit_should_be_lower_than_higher_price_limit
    if higher_price_limit.present? && (lower_price_limit > higher_price_limit)
      self.errors.add(:lower_price_limit, 'Lower price limit should be lower than higher price limit')
    end
  end

end
