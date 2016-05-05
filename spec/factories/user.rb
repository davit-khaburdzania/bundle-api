FactoryGirl.define do
  factory :user do |user|
    name { generate(:full_name) }
    email
    image
    username
    about
    auth_token
  end
end
