class ProductsController < ApplicationController

  theme :theme_resolver, only: [:index, :show]

  respond_to :html

  def index
    @page_title = 'Catalog'
    @products = Product.order(:name).all
    @product_groups = ProductGroup.all
    respond_with @products
  end

  def show
    @product = Product.find_by_permalink!(params[:id])
    @page_title = @product.name
    @product_groups = ProductGroup.all
    respond_with @product
  end

end
