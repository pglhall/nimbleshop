# TODO why rescue
Settings = Nimbleshop::Util.config2hash(Rails.root.join('config', 'nimbleshop.yml')) rescue nil

module Nimbleshop
  extend self

  def config
    Settings
  end
end
