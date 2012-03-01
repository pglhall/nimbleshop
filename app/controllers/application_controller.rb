class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :load_early, :set_shop
  helper_method :current_order, :current_shop

  protected

  def theme_resolver
    current_shop.theme
  end

  def current_order
    @current_order ||= begin
      return nil if session[:order_id].blank?
      order = Order.find_by_id(session[:order_id])
      order.blank? ? reset_order : order
    end
  end

  def reset_order
    session[:order_id] = nil
  end

  def load_early
    Address
  end

  def set_shop
    @product_groups = ProductGroup.all
    @main_nav_link_group = LinkGroup.last
    @shop_by_category_link_group = LinkGroup.find_by_permalink('shop-by-category')
    @shop_by_price_link_group = LinkGroup.find_by_permalink('shop-by-price')
  end

  def current_shop
    @shop ||= Shop.first
  end

  private

    def no_page_title
      @do_not_use_page_title = true
    end
end
