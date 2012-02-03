class Admin::ProductGroupsController < AdminController

  before_filter :load_product_group, only: [:edit, :update]

  def index
    @product_groups = ProductGroup.order('name asc')
  end

  def new
    @product_group = ProductGroup.new
    @product_group.product_group_conditions.build
  end

  def create
    @product_group = ProductGroup.new(params[:product_group])
    if @product_group.save
      redirect_to admin_product_groups_path, notice: t(:successfully_updated)
    else
      render 'new'
    end
  end

  def edit
    @custom_fields = CustomField.order('name asc').all
  end

  def update
    if @product_group.update_attributes(params[:product_group])
      redirect_to admin_product_groups_path, notice: t(:successfully_updated)
    else
      render 'edit'
    end
  end

  private

  def load_product_group
    @product_group = ProductGroup.find_by_permalink!(params[:id])
  end

end
