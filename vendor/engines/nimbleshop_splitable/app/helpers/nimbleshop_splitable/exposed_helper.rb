module NimbleshopSplitable
  module ExposedHelper

    def nimbleshop_splitable_stringified_form(f, order)
      return unless NimbleshopSplitable::Splitable.first.enabled?
      render partial: '/nimbleshop_splitable/splitables/form', locals: {order: order}
    end

  end
end
