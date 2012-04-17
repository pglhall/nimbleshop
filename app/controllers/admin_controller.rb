class AdminController < ApplicationController

  layout 'admin'

  before_filter :set_timezone

  private

    def set_timezone
      Time.zone = current_shop.time_zone
    end

end
