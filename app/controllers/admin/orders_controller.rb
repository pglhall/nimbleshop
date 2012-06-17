class Admin::OrdersController < AdminController

  respond_to :html

  def capture_payment
    @order = Order.find_by_number!(params[:id])
    @order.kapture!
    flash[:notice] = "Amount was successfully captured"
    redirect_to admin_order_path(@order)
  end

  def purchase_payment
    @order = Order.find_by_number!(params[:id])
    @order.purchase!
    flash[:notice] = "Amount was successfully paid"
    redirect_to admin_order_path(@order)
  end

  def index
    @orders = Order.order('id desc')
    respond_with @orders
  end

  def show
    @order = Order.find_by_number!(params[:id])

    if @order.shipments.any?
      @shipment = @order.shipments.first
    else
      @shipment = @order.shipments.build
      @shipment.notify_customer = 1
    end
    respond_with @order
  end

end
