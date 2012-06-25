class AdminController < ApplicationController

  layout 'admin'

  before_filter :set_timezone
  before_filter :restricted_access

  private

  def set_timezone
    Time.zone = current_shop.time_zone
  end

  def restricted_access
    return unless Nimbleshop.config.ask_admin_to_login

    authenticate_or_request_with_http_basic('staging') { |username, password|
      username == Nimbleshop.config.admin_email && password == Nimbleshop.config.admin_password
    }
  end

end
