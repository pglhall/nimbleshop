class Admin::ProductsController < AdminController

  before_filter :load_product!, only: [:show, :edit, :update, :destroy, :variants ]

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
    @page_title = 'Products'
    @products = Product.order(:id)
  end

  def show
    @page_title = "Product - #{@product.name}"
    @product_groups = ProductGroup.contains_product(@product)
  end

  def new
    @page_title = 'New product'
    @products = Product.order(:id)
    @product = Product.new
    @product.pictures.build
    @product.find_or_build_all_answers
  end

  def edit
    @page_title = 'Edit product'
    @product.find_or_build_all_answers
  end

  def create
    @product = Product.new(post_params[:product])
    if @product.save
      redirect_to admin_products_url, notice: t(:successfully_added)
    else
      render action: :new
    end
  end

  def update
    if @product.update_attributes(post_params[:product])
      redirect_to admin_products_path, notice: t(:successfully_updated)
    else
      render action: :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to admin_products_url, notice: t(:successfully_deleted)
  end

  private

    def post_params
      params.permit(product: [ :name, :status, :description, :price, :new, :variants_enabled] )
    end

    def load_product!
      @product = Product.find_by_permalink!(params[:id])
    end

end
