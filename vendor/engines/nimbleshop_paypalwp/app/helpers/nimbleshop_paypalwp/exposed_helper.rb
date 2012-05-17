module NimbleshopPaypalwp

  class Localhost2PublicUrl

    # returns public url for a given localhost url
    def self.url(url)
      #TODO rather than assuming that only in production one wants to return url
      #make it configurable using application.yml
      #
      return url if Rails.env.production?
      path = []

      tunnel = "#{Rails.root}/config/tunnel"

      if File.exists?(tunnel)
        host = File.open(tunnel, "r").gets.sub("\n", "")
        protocol = NimbleshopPaypalwp::Paypalwp.first.use_ssl ? 'https' : 'http'
        path << "#{protocol}://#{host}"
      end

      path << url

      path.join('')
    end
  end

  module ExposedHelper

    def nimbleshop_paypalwp_stringified_form(f, order)
      return unless NimbleshopPaypalwp::Paypalwp.first.enabled?
      render partial: '/nimbleshop_paypalwp/paypalwps/form', locals: {order: order}
    end

    def nimbleshop_paypalwp_notify_url
      Localhost2PublicUrl.url('/admin/payment_methods/nimbleshop_paypalwp/paypalwp/notify')
    end

    def nimbleshop_paypalwp_return_url(order)
      Localhost2PublicUrl.url(paid_order_path(id: order.number, payment_method: :paypal))
    end

    def nimbleshop_paypalwp_cancel_url(order)
      Localhost2PublicUrl.url(cancel_order_path(id: order.number))
    end

  end
end
