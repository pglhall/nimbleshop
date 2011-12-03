class ShippingMethod < ActiveRecord::Base

  belongs_to :shipping_zone

  def condition_in_english
    'tbd'
  end

end
