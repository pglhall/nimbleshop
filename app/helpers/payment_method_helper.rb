module PaymentMethodHelper

  def paypal_website_payments_standard_enabled?
    PaymentMethod.find_by_permalink('paypal-website-payments-standard').try(:enabled)
  end

  def authorize_net_enabled?
    PaymentMethod.find_by_permalink('authorize-net').try(:enabled)
  end

  def splitable_enabled?
    PaymentMethod.find_by_permalink('splitable').try(:enabled)
  end

  def build_payment_method_tabs
    result = []

    options = params[:action] == 'index' ? {class: 'active'} : nil
    result << content_tag(:li, link_to('Payment methods', admin_payment_methods_path), options)

    @enabled_payment_methods.each do |payment_method|
      case payment_method.permalink
        when 'splitable'
          options = (params[:controller] == 'admin/paymentmethod/splitables') ? { 'class' => 'active' } : {}
          url = admin_paymentmethod_splitable_path
        when 'authorize-net'
          options = (params[:controller] == 'admin/paymentmethod/authorizedotnets') ? { 'class' => 'active' } : {}
          url = admin_paymentmethod_authorizedotnet_path
        when 'paypal-website-payments-standard'
          options = (params[:controller] == 'admin/paymentmethod/paypalwebsite_payments_standards') ? { 'class' => 'active' } : {}
          url = admin_paymentmethod_paypalwebsite_payments_standard_path
        end
      result << content_tag(:li, link_to(payment_method.name, url), options)
    end

    result.join.html_safe
  end

end
