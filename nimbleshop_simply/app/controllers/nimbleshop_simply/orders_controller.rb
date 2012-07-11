module NimbleshopSimply
  class OrdersController < SimplyController

    before_filter :verify_current_order,  only: [:edit_shipping_method, :update_shipping_method, :edit, :update]
    before_filter :reset_order, only: [ :show ]

    respond_to :html

    def show
      @page_title     = 'Purchase is complete'
      @order          = Order.find_by_number!(params[:id])
      @payment_method = @order.payment_method

      respond_with(@order)
    end

    private

    def verify_current_order
      redirect_to root_path unless current_order
    end

  end
end
