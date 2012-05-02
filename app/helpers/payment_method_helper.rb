module PaymentMethodHelper
  def build_payment_method_tabs
    result = []

    options = params[:action] == 'index' ? {class: 'active'} : nil
    result << content_tag(:li, link_to('Payment methods', main_app.admin_payment_methods_path), options)

    @enabled_payment_methods.each do |payment_method|
      url = case payment_method.permalink
              when 'splitable'
                options = (params[:controller] == 'splitable_extension/splitables') ? { 'class' => 'active' } : {}
                splitable_extension.splitable_path

              when 'authorize-net'
                options = (params[:controller] == 'authorizedotnet_extension/authorizedotnets') ? { 'class' => 'active' } : {}
                authorizedotnet_extension.authorizedotnet_path

              when 'paypal-website-payments-standard'
                options = (params[:controller] == 'paypal_extension/paypals') ? { 'class' => 'active' } : {}
                paypal_extension.paypal_path
            end

      result << content_tag(:li, link_to(payment_method.name, url), options)
    end

    result.join.html_safe
  end
end
