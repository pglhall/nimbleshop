class Admin::OrdersController < AdminController

  def index
    @orders = Order.order('id desc')
  end

end
