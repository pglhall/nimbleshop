FactoryGirl.define do
  factory :shop do |f|
    sequence(:name){|n| "store-#{n}"}
    payment_gateway 'authorize_dot_net'
  end
end

