$:.push File.expand_path("../lib", __FILE__)

require "nimbleshop_splitable/version"

Gem::Specification.new do |s|
  s.name        = "nimbleshop_splitable"
  s.version     = NimbleshopSplitable::VERSION
  s.authors     = ["Neeraj Singh"]
  s.email       = ["neeraj@bigbinary.com"]
  s.homepage    = "http://www.bigbinary.com"
  s.summary     = "Splitable extension for Nimbleshop"
  s.description = "Splitable extension for Nimbleshop"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.3"

  # s.add_dependency "jquery-rails"
  s.add_development_dependency "sqlite3"
end
