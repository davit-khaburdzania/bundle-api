require 'rails_helper'

describe CollectionsSerializer, type: :serializer do
  let(:collections) { create_list(:collection, 5) }

  subject { serialize_array(collections) }

  it 'should serialize all objects' do
    expect(subject.length).to eq(collections.length)
  end

  it 'should have basic attributes' do
    attrs = ['name', 'bundles_count', 'favorites_count']

    attrs.each do |attr|
      expect(subject.first[attr]).to eq(collections.first[attr])
    end
  end


  it 'should have id' do
    expect(subject.first['id']).to eq(collections.first.slug)
  end

  it 'should have favorites_count' do
    expect(subject.first['favorites_count']).not_to be_nil
  end

  it 'should have favorited' do
    expect(subject.first['favorited']).not_to be_nil
  end

  it 'should have created_at' do
    expect(subject.first['created_at']).not_to be_nil
  end
end
