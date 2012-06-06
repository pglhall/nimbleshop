FactoryGirl.define do
  factory :payment_transaction do

    order

    trait :authorizedotnet do
      success 't'
      operation 'authorized'
      amount 11200
      transaction_gid "2172281042"
    end

    factory :payment_transaction_with_authorizedotnet,   traits: [ :authorizedotnet ]

  end
end
