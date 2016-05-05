FactoryGirl.define do
  factory :bundle do |bundle|
    name
    description

    bundle.creator { |c| c.association(:user) }
    bundle.collection { |c| c.association(:collection) }
  end
end
