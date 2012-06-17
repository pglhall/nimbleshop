#
# Following code will make the log less noisy by supressing log messages from assets.
# Given below is an example that will no longer appear because of code in this file
#
# Started GET "/assets/ajaxify-form.js?body=1" for 127.0.0.1 at 2012-03-29 17:39:21 -0400
# 0485e9d68ec9e33b34e32653efd5b61c] [127.0.0.1]
#
if Rails.env.development?  && false

  Rails.application.assets.logger = Logger.new('/dev/null')
  Rails::Rack::Logger.class_eval do
    def call_with_quiet_assets(env)
      previous_level = Rails.logger.level
      Rails.logger.level = Logger::ERROR if env['PATH_INFO'].index("/assets/") == 0
      call_without_quiet_assets(env).tap do
        Rails.logger.level = previous_level
      end
    end
    alias_method_chain :call, :quiet_assets
  end

end
