require 'spec_helper'

describe "admin" do
  include Capybara::DSL

  describe "product new" do
    it "should be at product show page" do
      visit new_admin_product_path
      #save_and_open_page
    end
  end

end
