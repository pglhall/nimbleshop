require 'active_merchant/billing/integrations/action_view_helper'

module PaymentMethodHelper
  include ActiveMerchant::Billing::Integrations::ActionViewHelper

  def order_confirmation_filename(order)
    order.payment_method.demodulized_underscore
  end

  def build_payment_method_tabs
    result = []

    options = params[:action] == 'index' ? {class: 'active'} : nil
    result << content_tag(:li, link_to('Payment methods', main_app.admin_payment_methods_path), options)

    @enabled_payment_methods.each do |payment_method|
      url = case payment_method.permalink
              when 'splitable'
                options = (params[:controller] == 'nimbleshop_splitable/splitables') ? { 'class' => 'active' } : {}
                nimbleshop_splitable.splitable_path

              when 'authorizedotnet'
                options = (params[:controller] == 'nimbleshop_authorizedotnet/authorizedotnets') ? { 'class' => 'active' } : {}
                nimbleshop_authorizedotnet.authorizedotnet_path

              when 'paypalwp'
                options = (params[:controller] == 'nimbleshop_paypalwp/paypalwps') ? { 'class' => 'active' } : {}
                nimbleshop_paypalwp.paypalwp_path
            end

      result << content_tag(:li, link_to(payment_method.name, url), options)
    end

    result.join.html_safe
  end

  # returns public url for a given localhost url
  def localhost2public_url(url, protocol)
    #TODO rather than assuming that only in production one wants to return url
    #make it configurable using application.yml
    return url if Rails.env.production?

    tunnel = "#{Rails.root}/config/tunnel"
    raise "File  #{Rails.root.join('config', 'tunnel').expand_path} is missing" unless File.exists?(tunnel)

    path = []


    host = File.open(tunnel, "r").gets.sub("\n", "")
    path << "#{protocol}://#{host}"

    path << url
    path.join('')
  end

end
