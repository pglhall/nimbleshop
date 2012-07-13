#
# This file is responsible for releasing newer version of nimbleshop gems.
# Here is the order in which it should be executed.
#
# rake nimbleshop:package_all
# rake nimbleshop:bundle_all
# git commit any changes to Gemfile and Gemfile.lock
# rake nimbleshop:release_all
#
require 'rake'
require File.expand_path('../../../nimbleshop_core/lib/nimbleshop/version', __FILE__)

pkg_dir = File.expand_path('../../pkg', __FILE__)
version = Nimbleshop::Version
engines = %w(core simply authorizedotnet paypalwp splitable cod).map { |i| "nimbleshop_#{i}" }
all = engines + ['nimbleshop']

all.each do |extension|

  namespace extension do
    extension_name = extension
    gem_filename = "pkg/#{extension}-#{version}.gem"
    gemspec = "#{extension_name}.gemspec"

    task :clean do
      mkdir_p pkg_dir unless File.exists? pkg_dir
      rm_f gem_filename
    end

    task :build do
      cmd = ''
      cmd << "cd #{extension} && " if extension != 'nimbleshop'
      cmd << "gem build #{gemspec} && "
      cmd << "mv #{extension_name}-#{version}.gem #{pkg_dir}/"
      puts cmd
      system cmd
    end

    task :install do
      cmd = "cd #{pkg_dir} && gem install #{extension_name}-#{version}.gem"
      puts cmd
      system cmd
    end

    task :bundle do
      ENV['BUNDLE_GEMFILE'] = File.expand_path("../../../#{extension}/Gemfile", __FILE__)
      cmd = "cd #{extension} && bundle install"
      puts cmd
      system cmd
    end

    task :release_gem do
      cmd = "cd #{pkg_dir} && gem push #{extension_name}-#{version}.gem"
      puts cmd
      system cmd
    end

    task :package => [:clean, :build, :install]
    task :release => [:package, :release_gem]
  end
end

namespace :nimbleshop do

  desc 'Packages nimbleshop and other extensions as a gem'
  task :package_all => all.map { |e| "#{e}:package" }

  desc 'Runs bundle install on nimbleshop and other extensions'
  task :bundle_all => engines.map { |e| "#{e}:bundle" }

  desc 'Releases nimbleshop and other extensions as a gem'
  task :release_all => (all.map { |e| "#{e}:release" } << "nimbleshop:tag_the_release")

  desc 'Tag the release'
  task :tag_the_release do
    cmd = "git tag -a v#{version} -m 'version  #{version} '"
    sh cmd
    cmd = "git push --tags"
    sh cmd
  end

end
