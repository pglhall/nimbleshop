class Admin::ShippingZonesController < AdminController

  def index
    @shipping_zones = ShippingZone.all
  end

end
