class AdminController < ApplicationController
  layout 'admin'

  before_filter :authenticate
  before_filter :set_timezone

  private

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "admin" && password == Settings.http_basic_authentication_password
    end
  end

  def set_timezone
    Time.zone = @shop.time_zone
  end

end
