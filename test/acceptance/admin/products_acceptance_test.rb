require "test_helper"

class ProductsAcceptanceTest < ActionDispatch::IntegrationTest

  setup do
    Capybara.current_driver = :rack_test
    visit admin_path
    click_link 'Products'
    click_link 'add_new_product'
    assert page.has_content?("Add new product")

    fill_in 'Name', :with => 'the very wicked name for product'
    fill_in 'Description', :with => 'test desc for user'
    fill_in 'Price', :with => '45.99'
  end

  test "should create a new product without image" do
    click_button 'Submit'
    assert page.has_content?('Successfuly added')
    assert page.has_content?('the very wicked name for product')
  end

  test "should create a new product with image" do
    skip "it is hard to get to the file element to test uploading of picture" do
      attach_file "Picture", "#{Rails.root}/app/assets/stylesheets/admin.css"
      msg = %Q{Pictures picture You are not allowed to upload } <<
            %Q{"css" files, allowed types: ["jpg", "jpeg", "gif", "png"]}
      assert page.has_content?(msg)

      attach_file "Picture", "#{Rails.root}/spec/support/images/cookware.jpg"
      click_button 'Submit'
      assert page.has_xpath?("//img[@alt='Small_cookware']")
    end
  end

  test "should not create product with wrong params" do
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
  end

  test "should delete a product" do
    create(:product, name: 'ipad99')
    visit admin_path
    click_link 'Products'
    click_link 'Delete'
    assert page.has_content?("Successfuly deleted")
    refute page.has_content?('ipad99')
  end

end

class ProductsAcceptance2Test < ActionDispatch::IntegrationTest

  setup do
    Capybara.current_driver = :rack_test
    create(:product, name: 'test')
  end

  test "should edit a product" do
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

  test "should not allow to save product with wrong params" do
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

  test "show product" do
    create(:product, name: 'ipad', description: 'the description', price: 46.99)
    visit admin_path
    click_link 'Products'
    click_link 'ipad'

    assert page.has_content?("ipad $46.99")
    assert page.has_content?("the description")
  end

end
