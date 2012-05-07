class Admin::OrdersController < AdminController

  respond_to :html

  def index
    @page_title = 'Orders'
    @orders = Order.order('id desc')
    respond_with @orders
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
    respond_with @order
  end

end
