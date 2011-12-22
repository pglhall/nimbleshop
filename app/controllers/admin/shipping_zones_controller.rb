class Admin::ShippingZonesController < AdminController

  before_filter :load_shipping_zone, only: [:edit, :update, :destroy]

  def index
    @shipping_zones = ShippingZone.all
  end

  def new
    @shipping_zone = ShippingZone.new
  end

  def edit
    @shipping_zone = ShippingZone.find(params[:id])
  end

  def create
    @shipping_zone = ShippingZone.new(params[:shipping_zone])
    if @shipping_zone.save
      redirect_to admin_shipping_zones_path, notice: 'successfully created'
    else
      render 'new'
    end
  end

  def destroy
    if @shipping_zone.destroy
      redirect_to admin_shipping_zones_path, notice: 'successfully deleted'
    else
      redirect_to admin_shipping_zones_path, error: 'could not delete'
    end
  end

  private

  def load_shipping_zone
    @shipping_zone = ShippingZone.find_by_permalink!(params[:id])
  end

end
