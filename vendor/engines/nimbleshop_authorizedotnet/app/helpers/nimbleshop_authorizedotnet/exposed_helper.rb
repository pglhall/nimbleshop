module NimbleshopAuthorizedotnet
  module ExposedHelper

    def nimbleshop_authorizedotnet_stringified_form(f, order)
      return unless NimbleshopAuthorizedotnet::Authorizedotnet.first.enabled?
      render partial: '/nimbleshop_authorizedotnet/authorizedotnets/form', locals: {order: order, f: f}
    end

  end
end
