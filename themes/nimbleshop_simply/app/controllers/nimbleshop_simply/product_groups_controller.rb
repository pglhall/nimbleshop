module NimbleshopSimply
  class ProductGroupsController < SimplyController

    before_filter :no_page_title,   only: [:show]

    respond_to    :html

    def show
      @product_group        = ProductGroup.find_by_permalink!(params[:id])
      @products             = @product_group.products
      @link_groups          = LinkGroup.all
      @product_groups       = ProductGroup.all

      respond_with(@produt_group)
    end

  end
end
