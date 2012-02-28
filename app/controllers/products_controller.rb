class ProductsController < ApplicationController

  theme :theme_resolver, only: [:index, :show, :all_pictures]

  before_filter :no_page_title, only: [:all_prictures, :index]

  respond_to :html

  def index
    @page_title     = 'All products'
    @products       = Product.active.order(:name)
    @product_groups = ProductGroup.all

    respond_with @products
  end

  def show
    @product = Product.find_by_permalink!(params[:id])
    @page_title = @product.name
    @product_groups = ProductGroup.all

    respond_with @product
  end

  def all_pictures
    @no_top_bar = true
    @no_footer  = true
    @product    = Product.find_by_permalink!(params[:id])
    @page_title = "all pictures for #{@product.name}"

    respond_with @product
  end

  private

    def no_page_title
      @do_not_use_page_title = true
    end
end
