$:.push File.expand_path("../lib", __FILE__)

require "nimbleshop_simply/version"

Gem::Specification.new do |gem|
  gem.name        = "nimbleshop_simply"
  gem.version     = NimbleshopSimply::VERSION
  gem.authors     = ['Neeraj Singh', 'Megpha']
  gem.email       = ['neeraj@bigbinary.com']
  gem.homepage    = 'http://www.nimbleshop.org'
  gem.summary     = 'Authorize.net extension for nimbleShop'
  gem.description = 'Authorize.net extension for nimbleShop'

  gem.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.md"]

  gem.test_files = Dir["test/**/*"]

end
