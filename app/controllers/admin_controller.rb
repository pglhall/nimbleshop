class AdminController < ApplicationController

  layout 'admin'

  before_filter :set_timezone
  before_filter :restricted_access

  private

  def set_timezone
    Time.zone = current_shop.time_zone
  end

  def restricted_access
    return if Rails.env.test? || Rails.env.development?

    authenticate_or_request_with_http_basic('staging') { |username, password|
      username == 'admin@example.com' && password == 'welcome'
    }
  end

end
