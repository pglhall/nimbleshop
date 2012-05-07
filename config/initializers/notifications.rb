ActiveSupport::Notifications.subscribe "orders.add" do |name, start, finish, id, payload|
  msg = []
  msg << "name : " + name.inspect
  msg << "id : " + id.inspect
  msg << "payload  : "+ payload.inspect

  Rails.logger.info msg.inspect

  product_id = payload
  if product = Product.find_by_id(product_id)
    Gabba::Gabba.new(Shop.first.google_analytics_tracking_id, "nimbleshop.net").event("Cart", "AddToCart", product.name)
  end
end

