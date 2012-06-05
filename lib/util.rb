class Util

  # returns public url for a given localhost url
  #
  # Usage: localhost2public_url ( '/nimbleshop_paypal/notify', 'http' )
  #
  def self.localhost2public_url(url, protocol)
    return url unless Settings.use_localhost2public_url

    tunnel = Rails.root.join('config', 'tunnel')
    raise "File  #{Rails.root.join('config', 'tunnel').expand_path} is missing" unless File.exists?(tunnel)

    path = []

    host = File.open(tunnel, "r").gets.sub("\n", "")
    path << "#{protocol}://#{host}"

    path << url
    path.join('')
  end

end
