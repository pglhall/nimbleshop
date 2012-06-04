class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_order, :current_shop

  protected

  def theme_resolver
    current_shop.theme
  end

  def current_order
    @current_order ||= begin
      return nil if session[:order_id].blank?
      order = Order.find_by_id(session[:order_id])
      (order.blank? || !order.abandoned?) ? reset_order : order
    end
  end

  def reset_order
    session[:order_id] = nil
  end

  def current_shop
    @shop ||= Shop.first
    raise "The database base is empty. Please run bundle exec rake setup first." unless @shop
    @shop
  end

  private

  def no_page_title
    @do_not_use_page_title = true
  end

end
