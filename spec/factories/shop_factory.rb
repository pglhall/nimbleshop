FactoryGirl.define do
  factory :shop do |f|
    sequence(:name){|n| "store-#{n}"}
  end
end

