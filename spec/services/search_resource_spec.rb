require 'rails_helper'

describe SearchResource do
  let(:user) { create(:user) }
  let(:bundle) { create(:bundle, name: 'x test x', creator: user) }
  let(:collection) { create(:collection, name: 'x testz', creator: user) }

  describe '#search' do
    it 'should return hash' do
      search_result = SearchResource.new(user: user, query: 'test').search
      expect(search_result).to be_a(Hash)
    end

    it 'should return found collections' do
      search_result = SearchResource.new(user: user, query: 'test').search
      expect(search_result[:collections]).to eq([collection])
    end

    it 'should return found bundles' do
      search_result = SearchResource.new(user: user, query: 'test').search
      expect(search_result[:bundles]).to eq([bundle])
    end
  end
end
