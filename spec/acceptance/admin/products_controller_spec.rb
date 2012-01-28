require 'spec_helper'

describe "admin integration" do

  describe "product new" do
    it "should be at product show page" do
      visit new_admin_product_path
      #save_and_open_page
    end
  end

  describe "add product" do
    it "should create a product and display it on the list for correct data" do
      visit admin_products_path
      click_link '+ Add new product'

      fill_in 'Name', :with => 'the very wicked name for product'
      fill_in 'Description', :with => 'test desc for user'
      fill_in 'Price', :with => '45.99'
      attach_file "Picture", "#{Rails.root}/app/assets/images/visa.png"
      click_button 'Submit'

      page.has_content?('Successfuly added').must_equal true
      page.has_content?('the very wicked name for product').must_equal true
      page.has_xpath?("//img[@alt='Thumb_visa']").must_equal true
    end

    it "should not create a product for wrong params" do
      visit admin_products_path
      click_link '+ Add new product'
      attach_file "Picture", "#{Rails.root}/app/assets/stylesheets/admin.css"
      click_button 'Submit'

      page.has_content?("Name can't be blank").must_equal true
      page.has_content?("Description can't be blank").must_equal true
      page.has_content?("Price is not a number").must_equal true
      page.has_content?("Price can't be blank").must_equal true
      page.has_content?("Pictures picture You are not allowed to upload \"css\" files, allowed types: [\"jpg\", \"jpeg\", \"gif\", \"png\"]").must_equal true
      
      fill_in 'Price', :with => 'wrong price'
      click_button 'Submit'

      page.has_content?("Price is not a number").must_equal true
      page.has_content?("Price can't be blank").must_equal false
    end
        
  end
  
end
