module AdminHelper

  def build_payment_method_tabs
    result = []

    options = params[:action] == 'index' ? {class: 'active'} : nil
    result << content_tag(:li, link_to('Payment methods', admin_payment_methods_path), options)

    @enabled_payment_methods.each do |payment_method|
      options = params[:id] == payment_method.id.to_s ? {'class' => 'active'} : nil
      result << content_tag(:li, link_to(payment_method.name, admin_payment_method_path(payment_method)), options)
    end
    result.join.html_safe
  end

end
