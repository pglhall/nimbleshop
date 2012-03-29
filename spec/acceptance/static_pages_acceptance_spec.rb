require 'spec_helper'

describe "static_pages_acceptance_spec integration" do

  it "static pages" do
    visit root_path

    click_link 'About us'
    page.has_content?('is a would be open source Ruby on Rails e-commerce framework').must_equal true

    click_link 'Contact us'
    page.has_content?('hello.nimbleshop@gmail.com').must_equal true

  end
end
