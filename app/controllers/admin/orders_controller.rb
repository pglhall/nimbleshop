class Admin::OrdersController < AdminController

  def index
    @page_title = 'Orders'
    @orders = Order.order('id desc')
  end

  def show
    @order = Order.find_by_number!(params[:id])
    @page_title = "Order # #{@order.number}"

    if @order.shipments.any?
      @shipment = @order.shipments.first
    else
      @shipment = @order.shipments.build
      @shipment.notify_customer = 1
    end
  end

end
