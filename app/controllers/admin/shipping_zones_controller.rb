class Admin::ShippingZonesController < AdminController

  before_filter :load_shipping_zone, only: [:edit, :update, :destroy]

  def index
    @page_title = 'shipping zone'
    @shipping_zones = CountryShippingZone.order('name asc')
  end

  def new
    @page_title = 'new shipping zone'
    @shipping_zone = ShippingZone.new
  end

  def edit
    @page_title = 'edit shipping zone'
  end

  def update
    if @shipping_zone.update_attributes(post_params[:shipping_zone])
      redirect_to admin_shipping_zones_path, notice: t(:successfully_updated)
    else
      render action: :edit
    end
  end

  def create
    @shipping_zone = CountryShippingZone.new(post_params[:shipping_zone])
    if @shipping_zone.save
      redirect_to admin_shipping_zones_path, notice: t(:successfully_created)
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

    def post_params
      params.permit(shipping_zone: [ :name, :country_code, :state_code, :country_shipping_zone_id])
      #params[:shipping_zone]
    end

    def load_shipping_zone
      @shipping_zone = ShippingZone.find_by_permalink!(params[:id])
    end

end
