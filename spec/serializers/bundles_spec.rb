require 'rails_helper'

describe BundlesSerializer, type: :serializer do
  let(:bundles) { create_list(:bundle, 5) }
  subject { serialize_array(bundles) }

  it 'should serialize all objects' do
    expect(subject.length).to eq(bundles.length)
  end

  it 'should have basic attributes' do
    attrs = ['name', 'description', 'links_count']

    attrs.each do |attr|
      expect(subject.first[attr]).to eq(bundles.first[attr])
    end
  end


  it 'should have id' do
    expect(subject.first['id']).to eq(bundles.first.slug)
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
