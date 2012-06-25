class Admin::ShippingMethodsController < AdminController

  before_filter :load_shipping_zone
  before_filter :load_shipping_method, except: [:new, :create, :enable]

  respond_to :html

  def update_offset
    @shipping_method.update_offset(params[:offset])
    render json: { html:  render_shipping_method(@shipping_method) }
  end

  def disable
    @shipping_method.disable!
    render json: { html:  render_shipping_method(@shipping_method) }
  end

  def enable
    @shipping_method = ShippingMethod.where(shipping_zone_id: @shipping_zone.id, id: params[:id]).first

    @shipping_method.enable!
    render json: { html:  render_shipping_method(@shipping_method) }
  end

  def new
    @shipping_method = @shipping_zone.shipping_methods.build
    respond_with @shipping_method
  end

  def edit
    respond_with @shipping_method
  end

  def create
    respond_to do |format|
      format.html do

        @shipping_method = @shipping_zone.shipping_methods.build(params[:shipping_method])
        if @shipping_method.save
          redirect_to admin_shipping_zones_path, notice: t(:successfully_created)
        else
          render action: :new
        end

      end
    end
  end

  def update
    respond_to do |format|
      format.html do

        @shipping_method = @shipping_zone.shipping_methods.find(params[:id])

        if @shipping_method.update_attributes(params[:shipping_method])
          redirect_to [:edit, :admin, @shipping_zone, @shipping_method], notice: t(:successfully_updated)
        else
          render action: :new
        end

      end
    end
  end

  def destroy
    if @shipping_method.update_attributes(active: false)
      redirect_to admin_shipping_zones_path, notice: t(:successfully_deleted)
    else
      redirect_to admin_shipping_zones_path, error: t(:could_not_delete)
    end
  end

  private

  def load_shipping_method
    @shipping_method = @shipping_zone.shipping_methods.find_by_id!(params[:id])
  end

  def load_shipping_zone
    @shipping_zone = ShippingZone.find_by_permalink!(shipping_zone_param)
  end

  def shipping_zone_param
    params[:country_shipping_zone_id] ||
    params[:regional_shipping_zone_id] ||
    params[:shipping_zone_id]
  end

  def render_shipping_method(shipping_method)
    render_to_string(partial: 'admin/shipping_methods/shipping_method', locals: { shipping_method: shipping_method })
  end

end
