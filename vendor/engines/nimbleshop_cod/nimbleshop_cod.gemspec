$:.push File.expand_path("../lib", __FILE__)

require "nimbleshop_cod/version"

Gem::Specification.new do |s|
  s.name        = "nimbleshop_cod"
  s.version     = NimbleshopCod::VERSION
  s.authors     = ["Neeraj Singh"]
  s.email       = ["neeraj@bigbinary.com"]
  s.homepage    = "http://www.bigbinary.com"

  s.summary     = "Cash on delivery extension for Nimbleshop"
  s.description = "Cash on delivery extension for Nimbleshop"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.test_files = Dir["test/**/*"]

end
