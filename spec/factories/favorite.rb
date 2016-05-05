FactoryGirl.define do
  factory :favorite do |fav|
    fav.favoritable { |c| c.association(:bundle) }
  end
end
