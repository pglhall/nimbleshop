module NimbleshopAuthorizedotnet
  module ExposedHelper

    def nimbleshop_authorizedotnet_payment_form(order)
      return unless NimbleshopAuthorizedotnet::Authorizedotnet.first.enabled?
      render partial: '/nimbleshop_authorizedotnet/payments/new', locals: {order: order}
    end

    def nimbleshop_authorizedotnet_crud_form
      return unless NimbleshopAuthorizedotnet::Authorizedotnet.first.enabled?
      render partial: '/nimbleshop_authorizedotnet/authorizedotnets/edit'
    end

    def nimbleshop_authorizedotnet_mini_image
      image_tag('authorize_net_logo.png', width: 200)
    end

  end
end