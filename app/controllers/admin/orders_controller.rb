class Admin::OrdersController < AdminController

  def index
    @orders = Order.order('id desc')
  end

  def show
    @order = Order.find_by_number!(params[:id])
  end

end
