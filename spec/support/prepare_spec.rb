module PrepareSpec
  extend ActiveSupport::Concern

  included do
    before :each do
      DatabaseCleaner.clean
      create(:shop)
      create(:link_group, name: "Shop by category", permalink: 'shop-by-category')
      create(:link_group, name: "Shop by price", permalink: 'shop-by-price')
      PaymentMethod.load_default!
    end
  end
end
