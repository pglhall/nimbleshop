require 'spec_helper'

describe "products_acceptance_spec integration" do
  before do
    Capybara.current_driver = :rack_test
  end

  describe "create product" do
    before do
      visit admin_path
      click_link 'Products'
      click_link 'add_new_product'
      assert page.has_content?("Add new product")

      fill_in 'Name', :with => 'the very wicked name for product'
      fill_in 'Description', :with => 'test desc for user'
      fill_in 'Price', :with => '45.99'
    end
    describe "should create a new product without image" do
      it {
        click_button 'Submit'
        assert page.has_content?('Successfuly added')
        assert page.has_content?('the very wicked name for product')
      }
    end

    describe "should create a new product with image" do
      it {
        skip "it is hard to get to the file element to test uploading of picture" do

        attach_file "Picture", "#{Rails.root}/app/assets/stylesheets/admin.css"
        msg = %Q{Pictures picture You are not allowed to upload } <<
              %Q{"css" files, allowed types: ["jpg", "jpeg", "gif", "png"]}
        assert page.has_content?(msg)


          attach_file "Picture", "#{Rails.root}/spec/support/images/cookware.jpg"
          click_button 'Submit'
          assert page.has_xpath?("//img[@alt='Small_cookware']")
        end
      }
    end

    describe "should not create product with wrong params" do
      it {
        visit admin_path
        click_link 'Products'
        click_link 'add_new_product'
        click_button 'Submit'

        assert page.has_content?("Name can't be blank")
        assert page.has_content?("Description can't be blank")
        assert page.has_content?("Price is not a number")
        assert page.has_content?("Price can't be blank")

        fill_in 'Price', :with => 'wrong price'
        click_button 'Submit'

        assert page.has_content?("Price is not a number")
        refute page.has_content?("Price can't be blank")
      }
    end
  end

  describe "should delete a product" do
    it {
      create(:product, name: 'ipad99')
      visit admin_path
      click_link 'Products'
      click_link 'Delete'
      assert page.has_content?("Successfuly deleted")
      refute page.has_content?('ipad99')
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
      click_button 'Submit'

      assert page.has_content?('Successfuly updated')
      assert page.has_content?('the very wicked name for product')
    end

    it "should not allow to save product with wrong params" do
      visit admin_path
      click_link 'Products'
      click_link 'Edit'

      fill_in 'Name', :with => ''
      fill_in 'Description', :with => ''
      fill_in 'Price', :with => 'wrong price'
      click_button 'Submit'

      assert page.has_content?("Name can't be blank")
      assert page.has_content?("Description can't be blank")
      assert page.has_content?("Price is not a number")
    end

  end

  describe "show product" do
    it {
      create(:product, name: 'ipad', description: 'the description', price: 46.99)
      visit admin_path
      click_link 'Products'
      click_link 'ipad'

      assert page.has_content?("ipad $46.99")
      assert page.has_content?("the description")
    }
  end

end
