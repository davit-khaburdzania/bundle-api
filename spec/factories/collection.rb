FactoryGirl.define do
  factory :collection do |collection|
    name
    collection.creator { |c| c.association(:user) }
    favorites_count 0
  end
end
