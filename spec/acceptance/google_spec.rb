require 'spec_helper'
describe "" do
  it "should browse" do
    Capybara.javascript_driver = :webkit
  end
end
