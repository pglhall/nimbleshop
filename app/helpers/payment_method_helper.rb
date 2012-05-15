module PaymentMethodHelper
  def build_payment_method_tabs
    result = []

    options = params[:action] == 'index' ? {class: 'active'} : nil
    result << content_tag(:li, link_to('Payment methods', main_app.admin_payment_methods_path), options)

    @enabled_payment_methods.each do |payment_method|
      url = case payment_method.permalink
              when 'splitable'
                options = (params[:controller] == 'nimbleshop_splitable/splitables') ? { 'class' => 'active' } : {}
                nimbleshop_splitable.splitable_path

              when 'authorize-net'
                options = (params[:controller] == 'nimbleshop_authorizedotnet/authorizedotnets') ? { 'class' => 'active' } : {}
                nimbleshop_authorizedotnet.authorizedotnet_path

              when 'paypal-website-payments-standard'
                options = (params[:controller] == 'nimbleshop_paypalwp/paypals') ? { 'class' => 'active' } : {}
                nimbleshop_paypalwp.paypalwp_path
            end

      result << content_tag(:li, link_to(payment_method.name, url), options)
    end

    result.join.html_safe
  end
end
