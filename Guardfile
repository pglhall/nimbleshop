# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'minitest', :verbose => false do
  # with Minitest::Unit
  #watch(%r|^test/test_(.*)\.rb|)
  #watch(%r|^lib/(.*)([^/]+)\.rb|)     { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  #watch(%r|^test/test_helper\.rb|)    { "test" }


  #watch(%r{^app/(.+)\.rb})             { |m| "spec/models/product_spec.rb" }

  # with Minitest::Spec
   watch(%r{^app/(.+)\.rb})             { |m| "spec/#{m[1]}_spec.rb" }
   watch(%r|^spec/(.*)_spec\.rb|)
   watch(%r|^lib/(.*)\.rb|)            { |m| "spec/lib/#{m[1]}_spec.rb" }
   watch(%r|^lib/search/(.*)\.rb|)     { |m| "spec/models/product_group_condition_spec.rb" }
   watch(%r|^lib/search.rb|)     { |m| "spec/models/product_group_condition_spec.rb" }
   watch(%r|^spec/spec_helper\.rb|)    { "spec" }
end
