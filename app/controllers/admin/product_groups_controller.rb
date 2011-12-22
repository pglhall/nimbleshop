class Admin::ProductGroupsController < AdminController

  before_filter :load_product_group, only: [:edit, :update]

  def index
    @product_groups = ProductGroup.all
  end

  def edit
    @custom_fields = CustomField.order('name asc').all
  end

  def update
    if @product_group.update_attributes(params[:product_group])
      redirect_to admin_product_groups_path, notice: 'successfully updated'
    else
      render 'edit'
    end
  end

  private

  def load_product_group
    @product_group = ProductGroup.find_by_permalink!(params[:id])
  end

end
