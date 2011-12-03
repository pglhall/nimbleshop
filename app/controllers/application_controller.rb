class ApplicationController < ActionController::Base
  #FIXME
  #protect_from_forgery

  before_filter :set_shop
  helper_method :current_order, :current_shop

  protected

  def theme_resolver
    @shop.theme || 'spotless' || 'woodland'
  end

  def current_order
    # bad order_id in session
    session[:order_id] = nil unless Order.find_by_id(session[:order_id])

    if session[:order_id]
      @current_order ||= Order.find_by_id(session[:order_id])
    else session[:order_id].nil?
      @current_order = Order.create!
      session[:order_id] = @current_order.id
    end
    @current_order
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
