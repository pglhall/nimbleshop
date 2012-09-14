module NimbleshopEmberly
  class ProductsController < EmberlyController

    before_filter :no_page_title, only: [:all_prictures, :index]

    #respond_to :html, :json

    def index
      @products             = Product.active.order(:created_at)
      @link_groups          = LinkGroup.all
      @product_groups       = ProductGroup.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @products }
      end
    end

    def show
      @product        = Product.find_by_permalink!(params[:id])
      @page_title     = @product.name
      @product_groups = ProductGroup.all

      respond_with @product
    end

  end
end
