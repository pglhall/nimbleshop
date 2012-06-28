# More info at https://github.com/guard/guard#readme

guard 'minitest', :verbose => false do
   watch(%r{^app/(.+)\.rb})         { |m| "test/#{m[1]}_test.rb" }
   watch(%r{^app/models/(.+)\.rb})  { |m| "test/unit/#{m[1]}_test.rb" }
   watch(%r|^test/(.*)_test\.rb|)
   watch(%r|^lib/(.*)\.rb|)     	  { |m| "test/lib/#{m[1]}_test.rb" }
   watch(%r|^lib/search/(.*)\.rb|)  { |m| "test/models/product_group_condition_test.rb" }
   watch(%r|^lib/search.rb|)     	  { |m| "test/models/product_group_condition_test.rb" }
   watch(%r|^test/test_helper\.rb|) { "test" }
end
