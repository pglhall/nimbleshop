module NimbleshopAuthorizedotnet
  module ExposedHelper

    def nimbleshop_authorizedotnet_payment_form(order)
      return unless NimbleshopAuthorizedotnet::Authorizedotnet.first.enabled?
      render partial: '/nimbleshop_authorizedotnet/payments/new', locals: {order: order}
    end

  end
end
