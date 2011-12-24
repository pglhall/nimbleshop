class Admin::ProductsController < AdminController

  before_filter :load_product, only: [:show, :edit, :update, :destroy ]

  respond_to :html

  def index
    @products = Product.where(:active => true).order(:name).paginate(
      :per_page => 12,
      :page     => params[:page]
    )

    respond_with @products
  end

  def show
    @product_groups = ProductGroup.contains_product(@product)
    respond_with @product
  end

  def new
    @product = Product.new
    @product.pictures.build
  end

  def edit
    render
  end

  def create
    @product = Product.new(params[:product])
    if @product.save
      redirect_to admin_products_url, notice: t(:successfully_added)
    else
      render action: :new
    end
  end

  def update
    if @product.update_attributes(params[:product])
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

  def load_product
    @product = Product.find_by_permalink!(params[:id])
  end

end
