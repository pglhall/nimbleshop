class NimbleshopSimply::SimplyController < ApplicationController

  layout 'simply'

  helper 'nimbleshop_simply/simply'

  helper_method :current_order, :current_shop

  protected

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
    @shop ||= Shop.current
    raise 'The database base is empty. Please run bundle exec rake setup first.' unless @shop
    @shop
  end

  def no_page_title
    @do_not_use_page_title = true
  end

  def verify_current_order
    redirect_to root_path unless current_order
  end

end
