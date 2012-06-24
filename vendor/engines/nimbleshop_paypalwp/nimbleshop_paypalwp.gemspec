$:.push File.expand_path("../lib", __FILE__)

require "nimbleshop_paypalwp/version"

Gem::Specification.new do |s|
  gem.name        = "nimbleshop_paypalwp"
  gem.version     = NimbleshopPaypalwp::VERSION
  gem.authors     = ["Neeraj Singh"]
  gem.email       = ["neeraj@bigbinary.com"]
  gem.homepage    = "http://www.bigbinary.com"

  gem.summary     = "Paypal WPS extension for nimbleshop"
  gem.description = "Paypal WPS extension for nimbleshop"

  gem.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.md"]

  gem.test_files = Dir["test/**/*"]

  gem.add_dependency "activemerchant"
end
