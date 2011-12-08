class Admin::ShippingZonesController < AdminController

  def index
    @shipping_zones = ShippingZone.all
  end

  def new
    @shipping_zone = ShippingZone.new
  end

  def edit
    @shipping_zone = ShippingZone.find(params[:id])
  end

end
