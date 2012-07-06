module NimbleshopHelper

    def body_id
      "#{params[:controller]}-#{params[:action]}".parameterize
    end

    def display_address(address)
      return if address.nil?
      address.full_address_array.map { |i| html_escape(i) }.join('<br />').html_safe
    end

    def display_page_title
      if @page_title
        @page_title.html_safe +  "&mdash;".html_safe +  html_escape(current_shop.name)
      else
        Shop.first.name
      end
    end

  def page_title(title)
    @page_title = title
  end

  def parent_layout(layout)
    @view_flow.set(:layout,output_buffer)
    self.output_buffer = render(file: "layouts/#{layout}")
  end

  def body_class
    %|#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}|
  end

  def grouped_options_for_country_state_codes
    Carmen::Country.all.reduce({}) do |h, country|
      h[country.alpha_2_code] = country.subregions.map do |r|
        [r.name, r.code]
      end
      h
    end
  end


end
