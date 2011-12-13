class ShippingMethodsController < ApplicationController

  theme :theme_resolver, only: [:show, :new]

  def new
    @page_title = 'Pick a shipping method'
    @shipping_methods = ShippingMethod.order('shipping_price asc')
  end

  def show
    @product_group = ProductGroup.find_by_permalink!(params[:id])
    @products = @product_group.products
    @page_title = @product_group.name
  end

end
