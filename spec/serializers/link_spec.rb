require 'rails_helper'

describe LinkSerializer, type: :serializer do
  let(:link) { create(:link) }

  subject { serialize(link) }

  it 'should have basic attributes' do
    attrs = ['id', 'title', 'description', 'url', 'image']

    attrs.each do |attr|
      expect(subject[attr]).to eq(link[attr])
    end
  end

  it 'should have creator' do
    expect(subject['creator']).not_to be_nil
    expect(subject['creator']['id']).to eq(link.creator.id)
  end

  it 'should have created_at' do
    expect(subject['created_at']).not_to be_nil
  end
end
