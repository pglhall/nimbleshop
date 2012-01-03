# Do not actually deliver email unless it is production environment
if defined?(MailSafe::Config) && !Rails.env.production?
  MailSafe::Config.replacement_address = Settings.mail_safe_redirected_email
end

Nimbleshop::Application.configure do
  config.action_mailer.default_url_options = { :host => Settings.bare_url_with_port }
end

if Rails.env.development?
  # Following code will ensure that mailcatcher catches the mail
  Nimbleshop::Application.configure do
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = { :host => "localhost", :port => 1025 }
  end
end

if Rails.env.production? || Rails.env.staging?

  ActionMailer::Base.smtp_settings = {
    :address => 'smtp.sendgrid.net',
    :port => '25',
    :domain => 'chickscorner.com',
    :authentication => :plain,
    :user_name => 'johnie.walker@chickscorner.com',
    :password => 'welcome'
  }

end

