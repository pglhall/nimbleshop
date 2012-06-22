Settings = Util.config2hash(Rails.root.join('config', 'application.yml'))

# this is neeed to make attach_picture work
class FilelessIO < StringIO
  attr_accessor :original_filename
end
