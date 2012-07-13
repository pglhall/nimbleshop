class AdminController < ::ApplicationController

  layout 'admin'

  before_filter :set_timezone
  before_filter :restricted_access

  helper_method :current_shop

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

  def delayed_job_admin_authentication
    return true if Rails.env.development? || Rails.env.test?
  end

  def no_page_title
    @do_not_use_page_title = true
  end

  def current_shop
    @shop ||= Shop.current
    raise "The database base is empty. Please run bundle exec rake setup first." unless @shop
    @shop
  end

end
