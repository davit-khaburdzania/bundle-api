FactoryGirl.define do
  factory :auth_provider do |auth|
    uid
    provider

    auth.user { |c| c.association(:user) }
  end
end
