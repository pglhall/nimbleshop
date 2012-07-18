module NimbleshopSplitable
  class PaymentsController < ::ActionController::Base

    def create
      order       = Order.find_by_id(session[:order_id])
      processor   = NimbleshopSplitable::Processor.new(order: order)
      error, url  = processor.create_split(request: request)

      respond_to do |format|
        format.html do
          error ?  render(text: error) : redirect_to(url)
        end
      end
    end

  end
end
