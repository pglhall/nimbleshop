class Admin::ShippingZonesController < AdminController

  before_filter :load_shipping_zone, only: [:edit, :update, :destroy]

  def index
    @shipping_zones = ShippingZone.all
  end

  def new
    @shipping_zone = ShippingZone.new
  end

  def edit
    render
  end

  def update
    if @shipping_zone.update_attributes(params[:shipping_zone])
      redirect_to admin_shipping_zones_path, notice: t(:successfully_updated)
    else
      render action: :edit
    end
  end

  def create
    @shipping_zone = ShippingZone.new(params[:shipping_zone])
    if @shipping_zone.save
      redirect_to admin_shipping_zones_path, notice: t(:succssfully_created)
    else
      render action: :new
    end
  end

  def destroy
    if @shipping_zone.destroy
      redirect_to admin_shipping_zones_path, notice: t(:successfully_deleted)
    else
      redirect_to admin_shipping_zones_path, error: t(:could_not_delete)
    end
  end

  private

  def load_shipping_zone
    @shipping_zone = ShippingZone.find_by_permalink!(params[:id])
  end

end
