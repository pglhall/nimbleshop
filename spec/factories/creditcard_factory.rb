FactoryGirl.define do
  factory :creditcard do |f|
    cvv           '123'
    number        '4007000000027'
    cardtype      'visa'

    first_name  { Faker::Name.first_name  } 
    last_name   { Faker::Name.last_name   } 
    address1    { Faker::Address.street_address } 
    zipcode     { Faker::Address.zip_code } 
    expires_on  { 1.year.from_now }
    state         'Florida'

    trait :visa do
      cardtype  'visa'
      number    '4007000000027'
      cvv       '123'
    end

    trait :amex do
      cvv       '1123'
      cardtype  'amex'
      number    '370000000000002'
    end

    factory :visa_creditcard, traits: [:visa]
    factory :amex_creditcard, traits: [:amex]
  end
end
