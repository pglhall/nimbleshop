class Admin::ProductsController < AdminController

  before_filter :load_product!, only: [:show, :edit, :update, :destroy, :variants ]

  respond_to :html

  def variants
    # update variation name event if the variant data is invalid
    @product.update_variation_names(params)
    Product.transaction do
      @result = @product.update_attributes(params[:product])
    end

    respond_to do |format|
      format.js do
        if @result
          render json: {success: 'done'}
        else
          render json: {error: @product.errors.full_messages}
        end
      end
    end
  end

  def index
    @products = Product.order(:id)
    respond_with @products
  end

  def show
    @product_groups = ProductGroup.contains_product(@product)
    respond_with @products
  end

  def new
    @products = Product.order(:id)
    @product = Product.new
    @product.pictures.build
    @product.find_or_build_all_answers
    respond_with @product
  end

  def edit
    @product.find_or_build_all_answers
    respond_with @products
  end

  def create
    @product = Product.new(post_params[:product])
    if @product.save
      redirect_to admin_products_url, notice: t(:successfully_added)
    else
      respond_with @product
    end
  end

  def update
    if @product.update_attributes(post_params[:product])
      redirect_to edit_admin_product_path(@product), notice: t(:successfully_updated)
    else
      respond_with @product
    end
  end

  def destroy
    @product.destroy
    redirect_to admin_products_url, notice: t(:successfully_deleted)
  end

  private

  def post_params
    params.permit(product: [ :picture_attributes, :name, :status, :description, :price, :new, :variants_enabled, :pictures_order] )
  end

  def load_product!
    @product = Product.find_by_permalink!(params[:id])
  end

end
