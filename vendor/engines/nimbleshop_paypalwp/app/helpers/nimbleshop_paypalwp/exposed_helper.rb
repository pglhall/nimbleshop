module NimbleshopPaypalwp
  module ExposedHelper

    def nimbleshop_paypalwp_order_show_extra_info(order)
      return unless NimbleshopPaypalwp::Paypalwp.first
      render partial: '/nimbleshop_paypalwp/paypalwps/order_show_extra_info', locals: { order: order }
    end

    def nimbleshop_paypalwp_available_payment_options_icons
      return unless NimbleshopPaypalwp::Paypalwp.first
      image_tag 'paypal.png', alt: 'paypal icon'
    end

    def nimbleshop_paypalwp_icon_for_order_payment(order)
      image_tag('paypal.png')
    end

    def update_service_with_attributes(service, order)
      service.customer email: order.email

      service.billing_address order.final_billing_address.attributes.slice(:city, :address1,:address2, :state, :country,:zip)

      service.invoice      order.number
      service.line_items   order.line_items
      service.shipping     order.shipping_cost.to_f.round(2)
      service.tax          order.tax.to_f.round(2)

      service.notify_url         nimbleshop_paypalwp_notify_url
      service.return_url         nimbleshop_paypalwp_return_url(order)
      service.cancel_return_url  nimbleshop_paypalwp_cancel_url(order)
    end

    def nimbleshop_paypalwp_crud_form
      return unless NimbleshopPaypalwp::Paypalwp.first
      render partial: '/nimbleshop_paypalwp/paypalwps/edit'
    end

    def nimbleshop_paypalwp_mini_image
      image_tag('paypal_logo.png', width: 200)
    end

    def nimbleshop_paypalwp_payment_form(order)
       ActiveMerchant::Billing::Base.integration_mode = Rails.env.production? ? :production : :test
      return unless NimbleshopPaypalwp::Paypalwp.first
      render partial: '/nimbleshop_paypalwp/payments/new', locals: { order: order }
    end

    def nimbleshop_paypalwp_admin_form(order)
      raise 'boom'
      return unless NimbleshopPaypalwp::Paypalwp.first
      render partial: '/nimbleshop_paypalwp/paypalwps/form', locals: { order: order }
    end

    def nimbleshop_paypalwp_notify_url
      Util.localhost2public_url( '/nimbleshop_paypalwp/paypalwp/notify', nimbleshop_paypalwp_protocol )
    end

    def nimbleshop_paypalwp_return_url(order)
      Util.localhost2public_url( order_path(id: order.number), nimbleshop_paypalwp_protocol )
    end

    def nimbleshop_paypalwp_cancel_url(order)
      Util.localhost2public_url( new_order_checkout_payment_path(order), nimbleshop_paypalwp_protocol )
    end

    def nimbleshop_paypalwp_protocol
      NimbleshopPaypalwp::Paypalwp.first.mode == 'production' ? 'https' : 'http'
    end

  end
end
