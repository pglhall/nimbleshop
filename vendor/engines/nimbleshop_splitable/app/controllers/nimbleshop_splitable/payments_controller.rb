#TODO add respond_to
module NimbleshopSplitable
  class PaymentsController

    def create
      order       = Order.find_by_id(session[:order_id])
      processor   = NimbleshopSplitable::Processor.new(order: order)
      error, url  = processor.create_split(request: request)

      if error
        render text: error
      else
        redirect_to url
      end
    end

  end
end
