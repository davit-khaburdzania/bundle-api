require 'rails_helper'

describe SearchResourceSerializer, type: :serializer do
  let(:user) { create(:user) }

  let(:collection) { create(:collection, creator: user) }
  let(:bundle) { create(:bundle, creator: user) }

  let(:search_result) do
    { collections: [collection], bundles: [bundle] }
  end

  subject { serialize(search_result) }

  it 'should have collections' do
    expect(subject['collections'].length).to eq(search_result[:collections].length)
  end

  it 'should have bundles' do
    expect(subject['bundles'].length).to eq(search_result[:bundles].length)
  end
end
