module ApplicationHelper

  def parent_layout(layout)
    @view_flow.set(:layout,output_buffer)
    self.output_buffer = render(:file => "layouts/#{layout}")
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

  def countries_without_shipping_zone
    options_for_all_countries.reject { |_, t| country_codes_for_country_shipping_zone.include?(t) }
  end

  def countries_with_shipping_zone
    options_for_all_countries.select { |_, t| country_codes_for_country_shipping_zone.include?(t)}
  end

  def country_codes_for_country_shipping_zone
    CountryShippingZone.pluck(:country_code)
  end

  def disabled_shipping_zone_countries
    countries_with_shipping_zone.inject([]) { |result, element| result << [element[0], element[1], {disabled: :disabled}]}
  end

  def unconfigured_shipping_zone_countries
    (disabled_shipping_zone_countries + countries_without_shipping_zone).sort
  end

end
