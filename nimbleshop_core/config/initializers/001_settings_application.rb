# TODO why rescue
Settings = Util.config2hash(Rails.root.join('config', 'nimbleshop.yml')) rescue nil

module Nimbleshop
  extend self

  def config
    Settings
  end
end
