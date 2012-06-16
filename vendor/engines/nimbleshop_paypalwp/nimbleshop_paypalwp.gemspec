$:.push File.expand_path("../lib", __FILE__)

require "nimbleshop_paypalwp/version"

Gem::Specification.new do |s|
  s.name        = "nimbleshop_paypalwp"
  s.version     = NimbleshopPaypalwp::VERSION
  s.authors     = ["Neeraj Singh"]
  s.email       = ["neeraj@bigbinary.com"]
  s.homepage    = "http://www.bigbinary.com"

  s.summary     = "Paypal WPS extension for nimbleshop"
  s.description = "Paypal WPS extension for nimbleshop"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.test_files = Dir["test/**/*"]

  s.add_dependency "activemerchant"
end
