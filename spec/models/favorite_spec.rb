require 'rails_helper'

describe Favorite, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:favoritable) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'scopes' do
    it 'should have default scope' do
       expect(Favorite.all.order_values).to include('created_at DESC')
    end
  end
end
