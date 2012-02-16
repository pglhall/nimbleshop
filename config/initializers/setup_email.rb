ActionMailer::Base.delivery_method = :smtp

if Rails.env.production?|| (Rails.env.staging? && Settings.deliver_email_for_real_in_staging)

  ActionMailer::Base.smtp_settings = {
    user_name: Settings.sendgrid.username,
    password: Settings.sendgrid.password,
    domain: Settings.sendgrid.domain,
    address: "smtp.sendgrid.net",
    port: 587,
    authentication: :plain,
    enable_starttls_auto: true
  }

else

  ActionMailer::Base.smtp_settings = {
    user_name:      Settings.mailtrapio.username || "nimbleshop",
    password:       Settings.mailtrapio.password || "7663e1f272637a4b",
    address:        "mailtrap.io",
    port:           2525,
    authentication: :plain }

end

