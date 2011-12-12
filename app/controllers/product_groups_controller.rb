class ProductGroupsController < ApplicationController

  layout 'thin'
  theme :theme_resolver, only: [:show]

  def show
    @product_group = ProductGroup.find_by_permalink!(params[:id])
    @products = @product_group.products
    @page_title = @product_group.name
  end

end
