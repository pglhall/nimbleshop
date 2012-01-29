class Admin::ShippingMethodsController < AdminController

  before_filter :load_shipping_zone, only: [:new, :create, :destroy, :edit]

  def update_offset
    @shipping_zone = ShippingZone.find_by_permalink!(params[:regional_shipping_zone_id])
    @shipping_method = @shipping_zone.shipping_methods.find_by_id(params[:id])
    @shipping_method.update_offset(params[:offset])

    text = render_to_string(:partial => "admin/shipping_methods/shipping_method", :locals => { :shipping_method => @shipping_method })

    render json: { html:  text }
  end

  def new
    @shipping_method = @shipping_zone.shipping_methods.build
  end

  def edit
    @shipping_method = ShippingMethod.find(params[:id])
  end

  def create
    @shipping_method = @shipping_zone.shipping_methods.build(params[:shipping_method])
    if @shipping_method.save
      redirect_to admin_shipping_zones_path, notice: t(:successfully_created)
    else
      render action: :new
    end
  end

  def destroy
    @shipping_method = ShippingMethod.find(params[:id])
    if @shipping_method.update_attributes(active: false)
      redirect_to admin_shipping_zones_path, notice: t(:successfully_deleted)
    else
      redirect_to admin_shipping_zones_path, error: t(:could_not_delete)
    end
  end

  private

  def load_shipping_zone
    @shipping_zone = ShippingZone.find_by_permalink!(params[:country_shipping_zone_id])
  end

end
