FactoryGirl.define do
  factory :link do |link|
    title { generate(:name) }
    description
    image
    url

    link.creator { |c| c.association(:user) }
    link.bundle { |c| c.association(:bundle) }
  end
end
