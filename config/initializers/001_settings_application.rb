Settings = Util.config2hash(Rails.root.join('config', 'application.yml'))

module Nimbleshop
  extend self

  def config
    Settings
  end
end
