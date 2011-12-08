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
    if @shipping_method.destroy
      redirect_to admin_shipping_zones_path, notice: 'Record was deleted'
    else
      redirect_to admin_shipping_zones_path, error: 'Record could not be deleted'
    end

  end

end
