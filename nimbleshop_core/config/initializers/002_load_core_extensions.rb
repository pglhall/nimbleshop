
path = File.expand_path('../../../', __FILE__)

Dir.glob(Rails.root.join(path, 'lib', 'nimbleshop', 'core_ext', '**/*')).each do |f|
  unless File.directory? f
    require f
  end
end
