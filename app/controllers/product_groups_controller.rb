class ProductGroupsController < ApplicationController

  theme :theme_resolver, only: [:show]

  def show
    @do_not_use_page_title = true
    @product_group = ProductGroup.find_by_permalink!(params[:id])
    @products = @product_group.products
    @page_title = @product_group.name
  end

end
