include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :picture do |f|
    picture { fixture_file_upload(Rails.root.join('test', 'fixtures', 'files', 'avatar.png'), 'image/png') }
    product
    file_name nil
    content_type nil
    file_size nil
  end
end
