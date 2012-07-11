module NimbleshopSimply
  class ProductsController < SimplyController

    before_filter :no_page_title, only: [:all_prictures, :index]

    respond_to :html

    def index
      @products             = Product.active.order(:created_at)
      @link_groups          = LinkGroup.all
      @product_groups       = ProductGroup.all

      respond_with @products
    end

    def show
      @product        = Product.find_by_permalink!(params[:id])
      @page_title     = @product.name
      @product_groups = ProductGroup.all

      respond_with @product
    end

  end
end
