
Dir["**/*.rb"].each { |x| 
  new_name = x.gsub(/_spec/,'_test')
  if File.file?x 
    File.rename(x,new_name)
  end
}

