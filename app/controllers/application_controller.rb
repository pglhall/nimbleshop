class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_shop
  helper_method :current_order, :current_shop

  protected

  def theme_resolver
    @shop.theme
  end

  def current_order
    @current_order ||= Order.find_by_id(session[:order_id])
  end

  def reset_order
    session[:order_id] = nil
  end

  def set_shop
    @shop = Shop.first
    @product_groups = ProductGroup.all
    @main_nav_link_group = LinkGroup.last
    @cart = current_order
    @categories = LinkGroup.first.navigations.map do |nav|
      [nav.navigeable.url, nav.navigeable.name]
    end
    @shop_by_category_link_group = LinkGroup.find_by_permalink('shop-by-category')
    @shop_by_price_link_group = LinkGroup.find_by_permalink('shop-by-price')
  end

  def current_shop
    @shop
  end

end
