$:.push File.expand_path('../lib', __FILE__)

require "nimbleshop_splitable/version"

Gem::Specification.new do |gem|
  gem.name        = 'nimbleshop_splitable'
  gem.version     = NimbleshopSplitable::VERSION
  gem.authors     = ['Neeraj Singh']
  gem.email       = ['neeraj@bigbinary.com']
  gem.homepage    = 'http://www.bigbinary.com'

  gem.summary     = 'Splitable extension for Nimbleshop'
  gem.description = 'Splitable extension for Nimbleshop'

  gem.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.md"]

  gem.test_files = Dir["test/**/*"]

  gem.add_dependency "activemerchant"
end
