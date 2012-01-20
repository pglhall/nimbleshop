if Rails.env.production?

else
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    :user_name => "nimbleshop",
    :password => "7663e1f272637a4b",
    :address => "mailtrap.io",
    :port => 2525,
    :authentication => :plain }
end

