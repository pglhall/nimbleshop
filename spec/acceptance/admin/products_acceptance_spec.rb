require 'spec_helper'

describe "admin integration" do
  before do
    Capybara.current_driver = :rack_test
  end

  describe "create product" do
    describe "should create a new product" do
      it {
        visit admin_path
        click_link 'Products'
        click_link 'add_new_product'
        page.has_content?("Add new product").must_equal true

        fill_in 'Name', :with => 'the very wicked name for product'
        fill_in 'Description', :with => 'test desc for user'
        fill_in 'Price', :with => '45.99'
        attach_file "Picture", "#{Rails.root}/spec/support/images/cookware.jpg"
        click_button 'Submit'

        page.has_content?('Successfuly added').must_equal true
        page.has_content?('the very wicked name for product').must_equal true
        page.has_xpath?("//img[@alt='Small_cookware']").must_equal true
      }
    end

    describe "should not create product with wrong params" do
      it {
        visit admin_path
        click_link 'Products'
        click_link 'add_new_product'
        attach_file "Picture", "#{Rails.root}/app/assets/stylesheets/admin.css"
        click_button 'Submit'

        page.has_content?("Name can't be blank").must_equal true
        page.has_content?("Description can't be blank").must_equal true
        page.has_content?("Price is not a number").must_equal true
        page.has_content?("Price can't be blank").must_equal true

        msg = %Q{Pictures picture You are not allowed to upload } <<
              %Q{"css" files, allowed types: ["jpg", "jpeg", "gif", "png"]}

        page.has_content?(msg).must_equal true

        fill_in 'Price', :with => 'wrong price'
        click_button 'Submit'

        page.has_content?("Price is not a number").must_equal true
        page.has_content?("Price can't be blank").must_equal false
      }
    end
  end

  describe "should delete a product" do
    it {
      create(:product, name: 'the very wicked name for product')
      visit admin_path
      click_link 'Products'
      click_link 'Delete'
      page.has_content?("Successfuly deleted").must_equal true
      page.has_content?('the very wicked name for product').must_equal false
    }
  end

  describe "edit product" do
    before do
      create(:product, name: 'test')
    end

    it "should edit a product" do
      visit admin_path
      click_link 'Products'
      click_link 'Edit'

      fill_in 'Name', :with => 'the very wicked name for product'
      fill_in 'Description', :with => 'test desc for user'
      fill_in 'Price', :with => '45.99'
      attach_file "Picture", "#{Rails.root}/app/assets/images/visa.png"
      click_button 'Submit'

      page.has_content?('Successfuly updated').must_equal true
      page.has_content?('the very wicked name for product').must_equal true
      page.has_xpath?("//img[@alt='Small_visa']").must_equal true
    end

    it "should not allow to save product with wrong params" do
      visit admin_path
      click_link 'Products'
      click_link 'Edit'

      fill_in 'Name', :with => ''
      fill_in 'Description', :with => ''
      fill_in 'Price', :with => 'wrong price'
      attach_file "Picture", "#{Rails.root}/app/assets/stylesheets/admin.css"
      click_button 'Submit'

      page.has_content?("Name can't be blank").must_equal true
      page.has_content?("Description can't be blank").must_equal true
      page.has_content?("Price is not a number").must_equal true
      msg = %Q{Pictures picture You are not allowed to upload "css" files, allowed types: ["jpg", "jpeg", "gif", "png"]}
      page.has_content?(msg).must_equal true
    end

  end

  describe "show product" do
    it {
      create(:product, name: 'ipad', description: 'the description', price: 46.99)
      visit admin_path
      click_link 'Products'
      click_link 'ipad'

      page.has_content?("ipad $46.99").must_equal true
      page.has_content?("the description").must_equal true
    }
  end

end
