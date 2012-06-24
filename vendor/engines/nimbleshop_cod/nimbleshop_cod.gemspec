$:.push File.expand_path("../lib", __FILE__)

require "nimbleshop_cod/version"

Gem::Specification.new do |gem|
  gem.name        = 'nimbleshop_cod'
  gem.version     = NimbleshopCod::VERSION
  gem.authors     = ['Neeraj Singh', 'Megpha']
  gem.email       = ['neeraj@bigbinary.com']
  gem.homepage    = 'http://www.bigbinary.com'

  gem.summary     = "Cash on delivery extension for nimbleshop"
  gem.description = "Cash on delivery extension for nimbleshop"

  gem.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.md"]

  gem.test_files = Dir["test/**/*"]

end
