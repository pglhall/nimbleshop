Address
ShippingAddress
BillingAddress


Dir["#{Rails.root}/app/models/address.rb"].each do |model|
  require_or_load model
end
