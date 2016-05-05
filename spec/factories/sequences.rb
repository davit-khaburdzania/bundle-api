require 'ffaker'

FactoryGirl.define do
  sequence :full_name do
    FFaker::NameMX.full_name
  end

  sequence :email do
    FFaker::Internet.email
  end

  sequence :username do
    FFaker::Internet.user_name
  end

  sequence :image do
    FFaker::Avatar.image
  end

  sequence :about do
    FFaker::Lorem.phrase
  end

  sequence :name do
    rand(2..5).times.map { FFaker::Lorem.word }.join(' ')
  end

  sequence :description do
    FFaker::Lorem.sentence
  end

  sequence :id do
    FFaker::Address.building_number
  end

  sequence :uid do
    FFaker::Address.building_number
  end

  sequence :provider do
    FFaker::Lorem.word
  end

  sequence :auth_token do
    FFaker::Lorem.characters
  end

  sequence :url do
    FFaker::Internet.http_url
  end
end
