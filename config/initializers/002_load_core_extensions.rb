Dir.glob(Rails.root.join('lib', 'core_ext', '**/*')).each do |f|
  unless File.directory? f
    require f
  end
end
