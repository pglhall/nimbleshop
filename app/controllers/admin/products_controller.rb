class Admin::ProductsController < AdminController

  respond_to :html

  def index
    @products = Product.where(:active => true).order(:name).paginate(
      :per_page => 12,
      :page     => params[:page]
    )

    respond_with @products
  end

  def show
    @product = Product.find(params[:id])
    @product_groups = ProductGroup.contains_product(@product)
    respond_with @product
  end

  def new
    @product = Product.new
    @product.pictures.build
  end

  def edit
    @product = Product.find_by_id!(params[:id])
  end


  def create
    @product  = Product.new(params[:product])
    if @product.save
      redirect_to admin_products_url, notice: 'Successfully added'
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(params[:product])
      redirect_to admin_products_path, notice: "Successfully updated"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to admin_products_url, notice: 'Successfully deleted'
  end

end
