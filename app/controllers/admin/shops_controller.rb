class Admin::ShopsController < AdminController

  respond_to :html

  def edit
    respond_with(:admin, current_shop)
  end

  def update
    if current_shop.update_attributes(params[:shop])
      redirect_to edit_admin_shop_path, notice: 'Shop was successfully updated'
    else
      respond_with(:admin, current_shop)
    end
  end

end
