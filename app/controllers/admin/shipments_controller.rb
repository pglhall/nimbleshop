class Admin::ShipmentsController < AdminController

  def create
    @order = Order.find_by_number!(params[:order_id])
    @shipment = @order.shipments.build(params[:shipment])

    respond_to do |format|
      format.html do

        if @shipment.save
          @order.shipped
          redirect_to admin_order_path(@order)
        end

      end
    end
  end

end
