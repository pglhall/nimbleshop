require 'spec_helper'

describe "homepage_spec integration" do

  it "should be ok for good path" do
    visit root_path
    page.has_content?('powered by').must_equal true

    LinkGroup.delete_all
    visit root_path
    page.has_content?('powered by').must_equal true

  end
end
