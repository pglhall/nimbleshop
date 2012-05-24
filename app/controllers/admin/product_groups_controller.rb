class Admin::ProductGroupsController < AdminController

  before_filter :load_product_group, only: [:edit, :update, :destroy]

  respond_to :html

  def index
    @product_groups = ProductGroup.order('name asc')
    respond_with @product_groups
  end

  def new
    @product_group = ProductGroup.new
    @product_group.product_group_conditions.build
    respond_with @product_group
  end

  def create
    @product_group = ProductGroup.new(post_params[:product_group])
    if @product_group.save
      redirect_to admin_product_groups_path, notice: t(:successfully_updated)
    else
      respond_with @product_group
    end
  end

  def edit
    @custom_fields = CustomField.order('name asc')
    respond_with @product_group
  end

  def update
    if @product_group.update_attributes(post_params[:product_group])
      redirect_to admin_product_groups_path, notice: t(:successfully_updated)
    else
      respond_with @product_group
    end
  end

  def destroy
    if @product_group.destroy
      redirect_to admin_product_groups_path, notice: t(:successfully_deleted)
    else
      respond_with @product_group
    end
  end

  private

  def post_params
    params.permit(product_group: [:name, :product_group_conditions_attributes])
  end

  def load_product_group
    @product_group = ProductGroup.find_by_permalink!(params[:id])
  end

end
