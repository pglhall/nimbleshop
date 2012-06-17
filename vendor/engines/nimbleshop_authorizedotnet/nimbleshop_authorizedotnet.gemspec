$:.push File.expand_path("../lib", __FILE__)

require "nimbleshop_authorizedotnet/version"

Gem::Specification.new do |s|
  s.name        = "nimbleshop_authorizedotnet"
  s.version     = NimbleshopAuthorizedotnet::VERSION
  s.authors     = ["Neeraj Singh"]
  s.email       = ["neeraj@bigbinary.com"]
  s.homepage    = "http://www.bigbinary.com"

  s.summary     = "Authorize.net extension for nimbleshop"
  s.description = "Authorize.net extension for nimbleshop"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.test_files = Dir["test/**/*"]

  s.add_dependency "activemerchant"
end
