require 'rails_helper'

describe LinksSerializer, type: :serializer do
  let(:links) { create_list(:link, 5) }

  subject { serialize_array(links) }

  it 'should have basic attributes' do
    attrs = ['id', 'title', 'description', 'url', 'image']

    attrs.each do |attr|
      expect(subject.first[attr]).to eq(bundles.first[attr])
    end
  end

  it 'should serialize all objects' do
    expect(subject.length).to eq(links.length)
  end

  it 'should have created_at' do
    expect(subject.first['created_at']).not_to be_nil
  end
end
