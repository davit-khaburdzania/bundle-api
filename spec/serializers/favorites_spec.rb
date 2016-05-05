require 'rails_helper'

describe FavoritesSerializer, type: :serializer do
  let(:favorites) { create_list(:favorite, 1) }

  subject { serialize_array(favorites) }

  it 'includes ActiveModel::Serialization' do
    expect(described_class.include?(ActiveModel::Serialization)).to be_truthy
  end

  it 'should serialize all objects' do
    expect(subject.length).to eq(favorites.length)
  end

  it 'should have basic attributes' do
    attrs = ['id', 'favoritable_type']

    attrs.each do |attr|
      expect(subject.first[attr]).to eq(favorites.first[attr])
    end
  end

  it 'should have created_at' do
    expect(subject.first['created_at']).not_to be_nil
  end

  it 'should have favoritable' do
    expect(subject.first['favoritable']).not_to be_nil
  end
end
