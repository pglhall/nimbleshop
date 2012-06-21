class Admin::ShippingZonesController < AdminController

  before_filter :load_shipping_zone, only: [:edit, :update, :destroy]

  respond_to :html

  def index
    @shipping_zones = CountryShippingZone.order('name asc')
    respond_with @shipping_zones
  end

  def new
    @shipping_zone = ShippingZone.new
    respond_with @shipping_zone
  end

  def edit
    respond_with @shipping_zone
  end

  def update
    if @shipping_zone.update_attributes(post_params[:shipping_zone])
      redirect_to admin_shipping_zones_path, notice: t(:successfully_updated)
    else
      respond_with @shipping_zone
    end
  end

  def create
    @shipping_zone = CountryShippingZone.new(post_params[:shipping_zone])
    if @shipping_zone.save
      redirect_to admin_shipping_zones_path, notice: t(:successfully_created)
    else
      respond_with @shipping_zone
    end
  end

  def destroy
    respond_to do |format|
      format.html do
        
        if @shipping_zone.destroy
          redirect_to admin_shipping_zones_path, notice: t(:successfully_deleted)
        else
          redirect_to admin_shipping_zones_path, error: t(:could_not_delete)
        end

      end
    end
  end

  private

  def post_params
    params.permit(shipping_zone: [ :name, :country_code, :state_code, :country_shipping_zone_id])
  end

  def load_shipping_zone
    @shipping_zone = ShippingZone.find_by_permalink!(params[:id])
  end

end
