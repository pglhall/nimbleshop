class Admin::ShipmentsController < AdminController

  def create
    @order = Order.find_by_number!(params[:order_id])
    @shipment = @order.shipments.build(params[:shipment])
    if @shipment.save
      @order.shipped
      redirect_to admin_order_path(@order)
    end
  end

  def edit
    raise 'boom'

    render
  end

  def update
    raise 'boom'
    if @shop.update_attributes(params[:shop])
      redirect_to edit_admin_shop_path, notice: 'Shop was successfully updated'
    else
      render action: :edit
    end
  end

end
