module ApplicationHelper

  delegate :paypal_website_payments_standard, :authorize_net, :splitable, :to => Shop

  def parent_layout(layout)
    @view_flow.set(:layout,output_buffer)
    self.output_buffer = render(:file => "layouts/#{layout}")
  end

  def paypal_website_payments_standard_enabled?
    paypal_website_payments_standard.try(:enabled)
  end

  def authorize_net_enabled?
    authorize_net.try(:enabled)
  end

  def splitable_enabled?
    splitable.try(:enabled)
  end

  # returns nil if the product does not have a main picture
  def product_main_picture(product, version = :medium_plus)
    if pic = product.picture
      image_tag(pic.picture_url(version), alt: product.name)
    end
  end

  def items_count_in_cart
    current_order.blank? ? 0 : current_order.item_count
  end

  def body_class
    %|#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}|
  end

  def options_for_all_countries
    Carmen::Country.all.map { |t| [t.name, t.alpha_2_code] }
  end

  def grouped_options_for_country_state_codes
    Carmen::Country.all.inject({}) do |h, country|
      h[country.alpha_2_code] = country.subregions.map do |r|
        [r.name, r.code]
      end
      h
    end
  end

  def options_for_country(country_code)
    grouped_options_for_country_state_codes[country_code]
  end

  def options_for_countries(country_codes)
    country_codes.map {|t| [ Carmen::Country.coded(t).name, t ] }
  end

  def unconfigured_shipping_zone_countries
    ret = []
    existing = CountryShippingZone.all.map(&:country_code)
    options_for_all_countries.each do |_, x|
      existing.include?(x) ? ret << [_, x, :disabled => :disabled] : ret << [_, x]
    end
    ret
  end
end
