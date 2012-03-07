FactoryGirl.define do
  factory :base_address do
    country_code  'US'
    state_code    'FL'
    state_name    'Florida'

    trait :good do
      city        { Faker::Address.city     } 
      first_name  { Faker::Name.first_name  } 
      last_name   { Faker::Name.last_name   } 
      address1    { Faker::Address.street_address } 
    end

    trait :bad do
      city        nil 
      first_name  nil 
      last_name   nil
      address1    nil 
    end

    zipcode     { Faker::Address.zip_code } 

    factory :address,  class: Address,  traits: [:good], :parent => :base_address
    factory :shipping_address,  class: ShippingAddress, :parent => :base_address, traits: [:good], aliases: [:good_shipping_address]

    factory :billing_address,   class: BillingAddress,  :parent => :base_address, traits: [:good], aliases: [:good_billing_address]

    factory :bad_shipping_address,  class: ShippingAddress, :parent => :base_address, traits: [:bad] 
    factory :bad_billing_address,   class: BillingAddress,  :parent => :base_address, traits: [:bad] 
  end
end
