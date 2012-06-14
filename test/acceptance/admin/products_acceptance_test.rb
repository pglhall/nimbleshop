require "test_helper"

class ProductsAcceptanceTest < ActionDispatch::IntegrationTest

  setup do
    visit admin_path
    click_link 'Products'
    click_link 'add_new_product'
    assert page.has_content?("Add new product")

    fill_in 'Name', with: 'the very wicked name for product'
    fill_in 'Description', with: 'test desc for user'
    fill_in 'Price', with: '45.99'
  end

  test "should create a new product without image" do
    click_button 'Submit'
    assert page.has_content?('Successfully added')
    assert page.has_content?('the very wicked name for product')
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

    fill_in 'Price', with: 'wrong price'
    click_button 'Submit'

    assert page.has_content?("Price is not a number")
    refute page.has_content?("Price can't be blank")
  end

  test "should delete a product" do
    create(:product, name: 'ipad99')
    visit admin_path
    click_link 'Products'
    click_link 'Delete'
    assert page.has_content?("Successfully deleted")
    refute page.has_content?('ipad99')
  end

end

class ProductsAcceptance2Test < ActionDispatch::IntegrationTest

  setup do
    create(:product, name: 'test')
  end

  test "should edit a product" do
    visit admin_path
    click_link 'Products'
    click_link 'Edit'

    fill_in 'Name', with: 'the very wicked name for product'
    fill_in 'Description', with: 'test desc for user'
    fill_in 'Price', with: '45.99'
    click_button 'Submit'

    assert page.has_content?('Successfully updated')
    assert page.has_content?('the very wicked name for product')
  end

  test "should not allow to save product with wrong params" do
    visit admin_path
    click_link 'Products'
    click_link 'Edit'

    fill_in 'Name', with: ''
    fill_in 'Description', with: ''
    fill_in 'Price', with: 'wrong price'
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

    assert page.has_content?("Edit product")
  end
end

