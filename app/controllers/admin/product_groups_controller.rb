class Admin::ProductGroupsController < AdminController

  def index
    @product_groups = ProductGroup.all
  end

  def show
    @product_group = ProductGroup.find(params[:id])
    @products = Product.all
  end

  def edit
    @product_group = ProductGroup.find(params[:id])
    @custom_fields = CustomField.order('name asc').all
  end

  def update
    @product_group = ProductGroup.find(params[:id])
    if @product_group.update_attributes(params[:product_group])
      redirect_to admin_product_groups_path, notice: 'successfully updated'
    else
      render 'edit'
    end

  end

end
