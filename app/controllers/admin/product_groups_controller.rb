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

end
