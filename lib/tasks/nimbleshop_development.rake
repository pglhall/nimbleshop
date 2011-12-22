#
# Tasks mentioned here are useful for the development of nimbleSHOP. If are using
# nimbleSHOP and if you are not doing any nimbleSHOP development work then you
# can safely delete this file.
#

namespace :nimbleshop do
  desc "dump database after elimination data that is not needed"
  task :data_dump do
    Module.constants.select do |constant_name|
      constant = eval constant_name.to_s
      if not constant.nil? and constant.is_a? Class and constant.superclass == ActiveRecord::Base
        if constant === Picture || constant === Product
        else
          constant.delete_all
        end
      end
    end
    Rake::Task["db:data:dump"].invoke
  end
end
