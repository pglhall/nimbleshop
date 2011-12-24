class ShippingZone < ActiveRecord::Base

  include BuildPermalink

  has_many :shipping_countries
  has_many :shipping_methods, dependent: :destroy, :conditions => {active: true}

  validates_presence_of :name

  def to_param
    self.permalink
  end

end
