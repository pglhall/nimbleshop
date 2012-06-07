module ApplicationHelper

  def page_title(title)
    @page_title = title
  end

  def parent_layout(layout)
    @view_flow.set(:layout,output_buffer)
    self.output_buffer = render(:file => "layouts/#{layout}")
  end

  def body_class
    %|#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}|
  end

  def grouped_options_for_country_state_codes
    Carmen::Country.all.inject({}) do |h, country|
      h[country.alpha_2_code] = country.subregions.map do |r|
        [r.name, r.code]
      end
      h
    end
  end

  def countries_with_shipping_zone
    Util.countries_list_with_name_and_code.select { |_, t| CountryShippingZone.all_country_codes.include?(t)}
  end

end
