module NimbleshopSplitable
  module ExposedHelper

    def nimbleshop_splitable_payment_form(order)
      return unless NimbleshopSplitable::Splitable.first.enabled?
      render partial: '/nimbleshop_splitable/payments/new', locals: {order: order}
    end

    def nimbleshop_splitable_mini_image
      image_tag('splitable_logo.png', width: 200)
    end

  end
end
