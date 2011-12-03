class Admin::ShopsController < AdminController

  def edit
    render
  end

  def update
    @shop.update_attributes(params[:shop])
    redirect_to edit_admin_shop_path, notice: 'shop was successfully updated'
  end

end
