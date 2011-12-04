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

end
