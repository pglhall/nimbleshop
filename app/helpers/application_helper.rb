module ApplicationHelper

  def items_count_in_cart
    current_order.blank? ? 0 : current_order.item_count
  end

  def body_class
    %|#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}|
  end

  def options_for_countries
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
end
