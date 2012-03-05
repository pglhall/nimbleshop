class ProductGroupsController < ApplicationController
  theme         :theme_resolver,  only: [:show]
  before_filter :no_page_title,   only: [:show]
  respond_to    :html

  def show
    @product_group  = ProductGroup.find_by_permalink!(params[:id])
    @products       = @product_group.products
    @page_title     = @product_group.name

    respond_with(@produt_group)
  end
end
