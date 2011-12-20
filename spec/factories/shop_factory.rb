FactoryGirl.define do
  factory :shop do |f|
    sequence(:name){|n| "store-#{n}"}
    twitter_handle '@nimbleshop'
  end
end

