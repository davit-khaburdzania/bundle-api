require 'rails_helper'

describe CollectionSerializer, type: :serializer do
  let(:collection) { create(:collection) }
  let(:bundle) { create(:bundle, collection: collection) }

  subject { serialize(collection) }

  it 'should have basic attributes' do
    attrs = ['name', 'bundles_count', 'favorites_count', 'favorites']

    attrs.each do |attr|
      expect(subject[attr]).to eq(collection[attr])
    end
  end

  it 'should have attribute' do
    expect(subject['id']).to eq(collection.slug)
  end


  it 'should have full_response attribute' do
    expect(subject['full_response']).to eq(true)
  end


  it 'should have created_at' do
    expect(subject['created_at']).not_to be_nil
  end

  it 'should have shares_count' do
    expect(subject['shares_count']).not_to be_nil
  end

  it 'should have favorited' do
    expect(subject['favorited']).not_to be_nil
  end

  it 'should have many bundles' do
    expect(subject['bundles'].length).to eq(collection.bundles.length)
  end
end
