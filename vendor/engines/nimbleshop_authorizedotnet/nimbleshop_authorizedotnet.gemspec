$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "nimbleshop_authorizedotnet/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "nimbleshop_authorizedotnet"
  s.version     = NimbleshopAuthorizedotnet::VERSION
  s.authors     = ["Neeraj Singh"]
  s.email       = ["neeraj@bigbinary.com"]
  s.homepage    = "http://www.bigbinary.com"
  s.summary     = "Authorize.net extension for nimbleshop"
  s.description = "Authorize.net extension for nimbleshop"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.3"

  # s.add_dependency "jquery-rails"
  s.add_development_dependency "sqlite3"
end
