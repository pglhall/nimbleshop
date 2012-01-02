class AdminController < ApplicationController
  layout 'admin'

  before_filter :set_timezone

  private

  def set_timezone
    Time.zone = @shop.time_zone
  end

end
