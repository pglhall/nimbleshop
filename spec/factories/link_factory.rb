FactoryGirl.define do
  factory :link do
    sequence(:name) { |t| "name#{t}" }
    url 'http://www.gogole.com/'
  end
end
