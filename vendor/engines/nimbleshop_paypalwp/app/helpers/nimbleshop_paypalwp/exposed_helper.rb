module NimbleshopPaypalwp

  module ExposedHelper

    def update_service_with_attributes(service, order)
      service.customer email: order.email

      service.billing_address order.final_billing_address.attributes.slice(:city, :address1,:address2, :state, :country,:zip)

      service.paymentaction NimbleshopPaypalwp::Paypalwp.first.paymentaction
      service.invoice      order.number
      service.line_items   order.line_items
      service.shipping     order.shipping_cost.to_f.round(2)
      service.tax          order.tax.to_f.round(2)

      service.notify_url         nimbleshop_paypalwp_notify_url
      service.return_url         nimbleshop_paypalwp_return_url(order)
      service.cancel_return_url  nimbleshop_paypalwp_cancel_url(order)
    end

    def nimbleshop_paypalwp_crud_form
      return unless NimbleshopPaypalwp::Paypalwp.first.enabled?
      render partial: '/nimbleshop_paypalwp/paypalwps/edit'
    end

    def nimbleshop_paypalwp_mini_image
      image_tag('paypal_logo.png', width: 200)
    end

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
      NimbleshopPaypalwp::Paypalwp.first.use_ssl? ? 'https' : 'http'
    end

  end
end
