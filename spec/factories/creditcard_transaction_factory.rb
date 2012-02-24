FactoryGirl.define do
  factory :creditcard_transaction do |f|
    order
    creditcard
    transaction_gid 'xxxxx'
    params '--  --'
    amount 50.00
    active false
    status 'authorized'
  end
end

