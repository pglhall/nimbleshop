class Admin::ShopsController < AdminController

  def edit
    render
  end

  def update
    if current_shop.update_attributes(params[:shop])
      redirect_to edit_admin_shop_path, notice: 'Shop was successfully updated'
    else
      render 'edit'
    end
  end

end
