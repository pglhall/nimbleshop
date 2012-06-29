$:.push File.expand_path("../lib", __FILE__)

require "nimbleshop_authorizedotnet/version"

Gem::Specification.new do |gem|
  gem.name        = "nimbleshop_authorizedotnet"
  gem.version     = NimbleshopAuthorizedotnet::VERSION
  gem.authors     = ["Neeraj Singh"]
  gem.email       = ["neeraj@bigbinary.com"]
  gem.homepage    = "http://www.bigbinary.com"

  gem.summary     = "Authorize.net extension for nimbleshop"
  gem.description = "Authorize.net extension for nimbleshop"

  gem.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  gem.test_files = Dir["test/**/*"]

  gem.add_dependency "activemerchant"
end
