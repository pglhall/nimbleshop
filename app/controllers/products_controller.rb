class ProductsController < ApplicationController

  theme :theme_resolver,        only: [:index, :show]

  before_filter :no_page_title, only: [:all_prictures, :index]

  respond_to :html

  def index
    @page_title     = 'All products'
    @products       = Product.active.order(:created_at)
    @product_groups = ProductGroup.all
    @link_groups          = LinkGroup.all
    @product_groups       = ProductGroup.all
    @main_nav_link_group  = LinkGroup.last

    respond_with @products
  end

  def show
    @product        = Product.find_by_permalink!(params[:id])
    @page_title     = @product.name
    @product_groups = ProductGroup.all

    respond_with @product
  end

end
