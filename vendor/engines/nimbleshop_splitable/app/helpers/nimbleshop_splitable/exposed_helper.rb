module NimbleshopSplitable
  module ExposedHelper

    def nimbleshop_splitable_payment_form(order)
      return unless NimbleshopSplitable::Splitable.first.enabled?
      render partial: '/nimbleshop_splitable/payments/new', locals: {order: order}
    end

  end
end
