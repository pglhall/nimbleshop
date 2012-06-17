module NimbleshopCod
  class Processor < ::Processor::Base

    attr_reader :order, :payment_method, :errors

    def initialize(order)
      @errors = []
      @order = order
      @payment_method = NimbleshopCod::Cod.first
    end

    private

    def do_purchase(options = {})
    end

  end
end
