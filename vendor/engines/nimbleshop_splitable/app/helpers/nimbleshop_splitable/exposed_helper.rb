module NimbleshopSplitable
  module ExposedHelper

    def nimbleshop_splitable_available_payment_options_icons
      return unless NimbleshopSplitable::Splitable.first
      image_tag 'splitable.png', alt: 'splitable icon'
    end

    def nimbleshop_splitable_payment_form(order)
      return unless NimbleshopSplitable::Splitable.first
      render partial: '/nimbleshop_splitable/payments/new', locals: {order: order}
    end

    def nimbleshop_splitable_crud_form
      return unless NimbleshopSplitable::Splitable.first
      render partial: '/nimbleshop_splitable/splitables/edit'
    end

    def nimbleshop_splitable_mini_image
      image_tag('splitable.png')
    end

    def nimbleshop_splitable_logo
      image_tag('splitable_logo.png')
    end

    def nimbleshop_splitable_icon_for_order_payment(order)
      nimbleshop_splitable_mini_image
    end

  end
end
