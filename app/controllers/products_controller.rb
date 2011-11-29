class ProductsController < ApplicationController

  theme :theme_resolver, only: [:index, :show]

  respond_to :html

  def index
    @page_title = 'catalog'
    @products = Product.order(:name).all
    @product_groups = ProductGroup.all
    respond_with @products
  end

  def show
    @product = Product.find(params[:id])
    @page_title = @product.name
    @product_groups = ProductGroup.all
    respond_with @product
  end

end
