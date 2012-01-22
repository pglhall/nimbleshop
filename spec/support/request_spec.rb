class RequestSpec < MiniTest::Spec
  include Rails.application.routes.url_helpers
  include Capybara::DSL
end

MiniTest::Spec.register_spec_type /integration$/i, RequestSpec
