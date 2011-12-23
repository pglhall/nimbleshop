class Admin::ShippingMethodsController < AdminController

  def edit
    @shipping_method = ShippingMethod.find(params[:id])
  end

  def update
    @shipping_method = ShippingMethod.find(params[:id])
    if @shipping_method.update_attributes(params[:shipping_method])
      redirect_to admin_shipping_zones_path, notice: 'Successfully updated'
    else
      render 'edit'
    end
  end

  def destroy
    @shipping_method = ShippingMethod.find(params[:id])
    if @shipping_method.update_attributes(active: false)
      redirect_to admin_shipping_zones_path, notice: 'Successfully deleted'
    else
      redirect_to admin_shipping_zones_path, error: 'Could not be delete'
    end

  end

end
