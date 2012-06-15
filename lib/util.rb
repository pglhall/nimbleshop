class Util

  # Converts the amount in cents and returns an integer.
  def self.in_cents(amount)
    (BigDecimal(amount.to_s) * 100).round(0).to_i
  end

  # returns public url for a given localhost url
  #
  # Usage: localhost2public_url ( '/nimbleshop_paypal/notify', 'http' )
  #
  def self.localhost2public_url(url, protocol)
    return url unless Settings.use_localhost2public_url

    tunnel = Rails.root.join('config', 'tunnel')
    return Settings.default_localhost2public_url unless File.exists?(tunnel)

    path = []

    host = File.open(tunnel, "r").gets.sub("\n", "")
    path << "#{protocol}://#{host}"

    path << url
    path.join('')
  end

  # The output is something like
  # ["Timor-Leste", "TL"], ["Turkmenistan", "TM"], ["Tunisia", "TN"], ["Tonga", "TO"], .......
  def self.countries_list_with_name_and_code
    Carmen::Country.all.map { |t| [t.name, t.alpha_2_code] }
  end

  def self.countries_without_shipping_zone
    Util.countries_list_with_name_and_code.reject { |_, t| CountryShippingZone.all_country_codes.include?(t) }
  end

  def self.disabled_shipping_zone_countries
    countries_with_shipping_zone.reduce([]) { |result, element| result << [element[0], element[1], {disabled: :disabled}]}
  end

  def self.unconfigured_shipping_zone_countries
    (Util.disabled_shipping_zone_countries + Util.countries_without_shipping_zone).sort
  end

  def self.countries_with_shipping_zone
    Util.countries_list_with_name_and_code.select { |_, t| CountryShippingZone.all_country_codes.include?(t)}
  end

end
