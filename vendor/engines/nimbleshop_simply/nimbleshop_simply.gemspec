$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "nimbleshop_simply/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "nimbleshop_simply"
  s.version     = NimbleshopSimply::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of NimbleshopSimply."
  s.description = "TODO: Description of NimbleshopSimply."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

end
