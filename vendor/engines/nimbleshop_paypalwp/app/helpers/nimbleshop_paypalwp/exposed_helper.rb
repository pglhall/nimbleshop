module NimbleshopPaypalwp

  module ExposedHelper

    def nimbleshop_paypalwp_payment_form(order)
      return unless NimbleshopPaypalwp::Paypalwp.first.enabled?
      render partial: '/nimbleshop_paypalwp/payments/new', locals: { order: order }
    end

    def nimbleshop_paypalwp_admin_form(order)
      raise 'boom'
      return unless NimbleshopPaypalwp::Paypalwp.first.enabled?
      render partial: '/nimbleshop_paypalwp/paypalwps/form', locals: { order: order }
    end

    def nimbleshop_paypalwp_notify_url
      localhost2public_url( '/admin/payment_methods/nimbleshop_paypalwp/paypalwp/notify', nimbleshop_paypalwp_protocol )
    end

    def nimbleshop_paypalwp_return_url(order)
      localhost2public_url( order_path(id: order.number), nimbleshop_paypalwp_protocol )
    end

    def nimbleshop_paypalwp_cancel_url(order)
      localhost2public_url( new_payment_processor_path, nimbleshop_paypalwp_protocol )
    end

    def nimbleshop_paypalwp_protocol
      NimbleshopPaypalwp::Paypalwp.first.use_ssl ? 'https' : 'http'
    end

  end
end
