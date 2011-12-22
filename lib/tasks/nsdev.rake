#
# Tasks mentioned here are useful for the development of nimbleSHOP. If are using
# nimbleSHOP and if you are not doing any nimbleSHOP development work then you
# can safely delete this file.
#

namespace :nsdev do
  desc "dump database after elimination data that is not needed"
  task :data_dump => :environment do
    ActiveRecord::Base.connection.tables.collect{|t| t.classify.constantize rescue nil }.compact.each do |klass|
      if Picture == klass || klass == Product
      else
        klass.delete_all
      end
    end

    Rake::Task["db:data:dump"].invoke
  end
end
