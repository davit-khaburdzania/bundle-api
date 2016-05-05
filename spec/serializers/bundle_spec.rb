require 'rails_helper'

describe BundleSerializer, type: :serializer do
  let(:bundle) { create(:bundle) }
  let(:link) { create(:link, bundle: bundle) }

  subject do
    link.reload
    serialize(bundle)
  end

  it 'should have basic attributes' do
    attrs = ['name', 'description', 'links_count']

    attrs.each do |attr|
      expect(subject[attr]).to eq(bundle[attr])
    end
  end

  it 'should have links' do
    expect(subject['links'].length).to eq(1)
    expect(subject['links'].first['id']).to eq(link.id)
  end

  it 'should have creator' do
    expect(subject['creator']).not_to be_nil
    expect(subject['creator']['id']).to eq(bundle.creator.id)
  end

  it 'should have id attribute' do
    expect(subject['id']).to eq(bundle.slug)
  end

  it 'should have full_response attribute' do
    expect(subject['full_response']).to eq(true)
  end

  it 'should have favorited' do
    expect(subject['favorited']).not_to be_nil
  end

  it 'should have favorites_count' do
    expect(subject['favorites_count']).not_to be_nil
  end

  it 'should have created_at' do
    expect(subject['created_at']).not_to be_nil
  end

  it 'should have collection_id' do
    expect(subject['collection_id']).not_to be_nil
  end
end
