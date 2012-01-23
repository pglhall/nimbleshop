FactoryGirl.define do
  factory :picture do |f|
    product
    picture_file_name nil
    picture_content_type nil
    picture_file_size nil
    picture_updated_at nil
  end
end
