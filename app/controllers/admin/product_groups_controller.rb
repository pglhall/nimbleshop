class Admin::ProductGroupsController < AdminController

  before_filter :load_product_group, only: [:edit, :update, :destroy]

  def index
    @page_title = 'Product groups'
    @product_groups = ProductGroup.order('name asc')
  end

  def new
    @page_title = 'New product groups'
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
    @page_title = 'Edit product groups'
    @custom_fields = CustomField.order('name asc')
  end

  def update
    if @product_group.update_attributes(params[:product_group])
      redirect_to admin_product_groups_path, notice: t(:successfully_updated)
    else
      render 'edit'
    end
  end

  def destroy
    @product_group.destroy
    redirect_to admin_product_groups_path, notice: t(:successfully_deleted)
  end

  private

  def load_product_group
    @product_group = ProductGroup.find_by_permalink!(params[:id])
  end

end
