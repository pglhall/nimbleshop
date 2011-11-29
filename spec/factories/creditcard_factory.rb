FactoryGirl.define do
  factory :creditcard do |f|
    first_name 'Johny'
    last_name 'walker'
    email 'johny.walker@example.com'
    cvv '123'
    month '11'
    year '2012'
    number '4007000000027'
    address1 '123 Main street'
    address2 'suite #100'
    zipcode '33324'
    city 'Miami'
    state 'Florida'
  end
end

